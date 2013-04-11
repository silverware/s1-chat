(ns s1-chat.models.chat
  (:use 
    s1-chat.models.user
    lamina.core))

(def session-id-ref (ref 0))

(def connected-users (ref {}))

(defn send-part [chan user]
  (enqueue (:channel chan) {:id 0 :type "part" :username (:name user) :chan-name (:name chan)}))

(defn on-user-disconnect [user] 
  (println "User " (:name user) " disconnected.")
  (dosync
    (alter connected-users dissoc (:name user))
    (dorun
      (map #(do
              (map (fn [channel] (close channel)) (@(:chans user) %)) 
              (alter (:users %) disj user)
              (send-part % user))
            (keys @(:chans user))))))


; authentication


(defn generate-session-id [] (dosync (alter session-id-ref inc)))

(defn get-user [username] (@connected-users username))

(defn valid-session-id? [username provided-id]
  (dosync (= (:session-id (@connected-users username)) provided-id)))

(defn auth
  [ch username password]
  (let [session-id (generate-session-id)
        user (assoc (->User username ch (ref {})) :session-id session-id)]
    (on-closed ch #(on-user-disconnect user))
    (dosync (alter connected-users assoc username user))
    session-id))

(load "message")
(load "chan")
