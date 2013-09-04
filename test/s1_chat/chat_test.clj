(ns s1-chat.chat-test
  (:require [s1-chat.server :as server])
  (:use s1-chat.models.chat 
        [aleph.formats :as formats]
        lamina.core
        clojure.test
        aleph.http))


(defn send-auth [ch]
  (enqueue ch {:type "auth" :username "Hans" :password "" :guest? true}))

(defn wrap-auth-json-channel [ch ticket]
    (splice
      (server/decode-json-channel ch)
      (let [ch-auth-json (channel)]
        (siphon (map* #(formats/encode-json->string (assoc % :ticket ticket)) ch-auth-json) ch)
        ch-auth-json)))

(defn ws-client []
  (server/wrap-json-channel @(websocket-client {:url "ws://localhost:8009"})))

(defn authed-ws-client 
  ([username]
  (let [ch @(websocket-client {:url "ws://localhost:8009"})]
    (enqueue ch (formats/encode-json->string {:type "auth" :username username :password "" :guest? true}))
    (let [{session-id :session-id} (formats/decode-json @(read-channel ch))]
      (println (str "session-id " session-id))
      (wrap-auth-json-channel ch {:username username :session-id session-id}))))

  ([] (authed-ws-client "Hans")))

(defmacro with-server [server & body]
  `(let [kill-fn# ~server]
     (try
       ~@body
       (finally
	 (kill-fn#)))))

(defmacro with-handler [handler & body]
  `(with-server 
     (start-http-server ~handler
                        {:port 8009
                         :websocket true
                         })
     (create-default-chans)
     (server/connect-db)
     ~@body))

(deftest session-id-test
         (let [id1 (generate-session-id) id2 (generate-session-id)]
           (is (not= id1 id2))))

(deftest auth-test
         (with-handler server/chat-handler
                       (let [ch (ws-client)]
                         (send-auth ch)
                         (is (= (:type @(read-channel ch)) "authsuccess")))))

(deftest join-test
         (with-handler server/chat-handler
                       (let [ch (authed-ws-client "Hans2")]
                         (enqueue ch
                                  {:type "join" 
                                   :chan-name "Hans"})
                         (is (= (:type @(read-channel ch)) "join"))
                         (is (= (:type @(read-channel ch)) "joinsuccess"))

                         (is (= (count @(:chans (get-user "Hans2"))) 1)))))


(deftest part-test
         (with-handler server/chat-handler
                       (let [ch (authed-ws-client "Hans") ch2 (authed-ws-client "Magic")]
                         (enqueue ch2
                                  {:type "join"
                                   :chan-name "Test"})
                         (is (= (:type @(read-channel ch2)) "join"))
                         (is (= (:type @(read-channel ch2)) "joinsuccess"))

                         (enqueue ch
                                  {:type "join"
                                   :chan-name "Test"})
                         (is (= (:type @(read-channel ch)) "join"))
                         (is (= (:type @(read-channel ch)) "joinsuccess"))
                         (is (= (count @(:users (get-chan "Test"))) 2))

                         (is (= (:type @(read-channel ch2)) "join"))

                         (enqueue ch 
                                  {:type "part"
                                   :chan-name "Test"})

                         (is (= (:type @(read-channel ch2)) "part"))
                         (is (= (count @(:users (get-chan "Test"))) 1)))))

(deftest channel-drained-test 
         (with-handler server/chat-handler
                       (let [ch (authed-ws-client "AAA") chan (create-chan "Test123") chan-ch (:channel chan)]
                         (enqueue ch {:type "join" :chan-name "Test123"})
                         (enqueue ch {:type "part" :chan-name "Test123"})
                         (is (= false (drained? chan-ch)))
                         (is (= false (closed? chan-ch))))))



; TODO: Tests fail if they all use the same Chan
