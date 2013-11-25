(ns s1-chat.models.chat
  (:require [monger.collection :as mc])
  (:use lamina.core
        s1-chat.controllers.login))

(defrecord User [name channel chans attr-map])

(def session-id-ref (ref 0))

(def connected-users (ref {}))

(defn send-part [chan user]
  (enqueue (:channel chan) {:id 0 :type "part" :username (:name user) :chan-name (:name chan)}))

(declare remove-user-from-chan)
(defn logout-user [user] 
  (println "User " (:name user) " disconnected.")
  (doseq [chan (keys @(:chans user))] (do 
                                        (send-part chan user)
                                        (remove-user-from-chan user chan)))
  (dosync
    (alter connected-users dissoc (:name user))
    (dorun
      (map #(do
              (map (fn [channel] (close channel)) (@(:chans user) %)) 
              (alter (:users %) disj user))
           (keys @(:chans user))))))


;; user to chat authentication

(defn generate-session-id [] (dosync (str (alter session-id-ref inc))))

(defn get-user [username] (@connected-users username))

(defn get-sanitized-user [username] 
  (let [user (get-user username)]
    (assoc (select-keys user [:name :attr-map]) :attr-map @(:attr-map user))))

(defn valid-session-id? [username provided-id]
  (dosync 
    (= (:session-id (@connected-users username)) (str provided-id))))

(defn auth
  [ch username password]
    (let [session-id (generate-session-id)
          user (assoc (->User username ch (ref {}) (ref {:guest? (empty? password)})) :session-id session-id)]
      (on-closed ch #(logout-user user))
      (dosync (alter connected-users assoc username user))
      session-id))

(defn append-attr [username attr value]
  (dosync (alter (:attr-map (get @connected-users username)) assoc attr value)))
