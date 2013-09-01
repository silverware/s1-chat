(ns s1-chat.models.chat
  (:require [monger.collection :as mc])
  (:use lamina.core
        s1-chat.controllers.login))

(defrecord User [name channel chans attr-map])

(def session-id-ref (ref 0))

(def connected-users (ref {}))

(defn send-part [chan user]
  (enqueue (:channel chan) {:id 0 :type "part" :username (:name user) :chan-name (:name chan)}))

(defn logout-user [user] 
  (println "User " (:name user) " disconnected.")
  (dosync
    (alter connected-users dissoc (:name user))
    (dorun
      (map #(do
              (map (fn [channel] (close channel)) (@(:chans user) %)) 
              (alter (:users %) disj user)
              (send-part % user))
            (keys @(:chans user))))))


;; user to chat authentication

(defn generate-session-id [] (dosync (alter session-id-ref inc)))

(defn get-user [username] (@connected-users username))

(defn valid-session-id? [username provided-id]
  (dosync (= (:session-id (@connected-users username)) provided-id)))

(defn auth
  [ch username password]
  (if (or (= 1 (mc/count "users" {:username username :password (hash-password password)})) (empty? password))
    (let [session-id (generate-session-id)
          user (assoc (->User username ch (ref {}) (ref {:guest? (empty? password)})) :session-id session-id)]
      (on-closed ch #(logout-user user))
      (dosync (alter connected-users assoc username user))
      session-id)
    (if (mc/any? "users" {:username username})
     :wrong-password
     :unknown-username)))
