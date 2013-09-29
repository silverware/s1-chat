(ns s1-chat.server
  (:require
    [monger.core :as mg]
    [aleph.formats :as formats]
    [s1-chat.config])

  (:use [aleph.http]
        [lamina.core]
        [s1-chat.models.chat]
        [s1-chat.validation]))

(defn decode-json-channel [ch]
  (map* formats/decode-json  ch))

(defn encode-json-channel [target-ch]
  (let [ch (channel)]
    (siphon (map* formats/encode-json->string ch) target-ch)
    ch))

(defn wrap-json-channel [ch]
    (splice
      (decode-json-channel ch)
      (encode-json-channel ch)))

(defn chat-handler [ch handshake]
  (let [json-ch (wrap-json-channel ch)]
  (receive-all json-ch
    #(let [msg % _type (:type msg) id (:id msg) validation (validate msg)]
       (println (str "Message:" msg))
       (if (not (empty? validation))
         (do
           (println "Errors: " validation)
           (doall (map (fn [error-text] (send-error json-ch id error-text)) validation)))
         (if (= _type "auth")
           (dispatch-auth-msg json-ch msg)
           (dispatch-message json-ch msg)))))))

(defn connect-db []
  (println "==========================")
  (println "  CONNECTING TO DATABASE  ")
  (println "==========================")
  (mg/connect! {:port (:mongodb-port s1-chat.config/properties)} )
  (mg/set-db! (mg/get-db "s1")))


(defn initialize-app []
  (when-not s1-chat.config/properties
    (s1-chat.config/initialize-properties "config.properties"))
  (connect-db)
  (println "==========================")
  (println "STARTING WEBSOCKET-SERVEUR")
  (println "==========================")
  (start-http-server chat-handler {:port 8008 :websocket true}))

