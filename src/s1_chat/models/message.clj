(ns s1-chat.models.chat
  (:require [s1-chat.validation :as vali]
            [clojure.string :as string])
  (:use aleph.formats lamina.core))

(load "chan")

(defn send-error [ch id text] (enqueue ch {:id id :type "error" :text text}))

(defn send-join-success [ch id usernames]
  (enqueue ch {:id id :type "joinsuccess" :usernames usernames}))


(defn remove-ticket [msg] (dissoc msg :ticket))

;; user to user query dispatch
(defn dispatch-query [{{username :username} :ticket :as original-msg}]
  (let [msg (assoc (remove-ticket original-msg) :username username) receivers (map get-user (:receivers msg))]
    (dorun (map #(enqueue (:channel %) msg) receivers)))) 

;; auth message dispatch
(defn send-auth-success [ch session-id]
  (enqueue ch {:type "authsuccess" :session-id session-id}))

(defn dispatch-auth-msg [ch {:keys [id username password]} ]
  (let [session-id (auth ch username password)]
    (if (not (nil? session-id))
      (send-auth-success ch session-id)
      (send-error ch id "Username or Password incorrect."))))

(defn dispatch-message 
  [ch {id :id {:keys [username session-id]} :ticket :as msg}]
  (let [user (get-user username)]
    (if (valid-session-id? username session-id)
      (case (:type msg)
        "join" (let [dest-chan (get-chan (:chan-name msg))]
                 (add-user-to-chan user dest-chan)
                 (enqueue (:channel dest-chan) msg)
                 (send-join-success ch id (map #(:name %) @(:users dest-chan))))
        "part" (let [chan (get-chan (:chan-name msg))]
                 (remove-user-from-chan user chan)
                 (send-part chan user))
        "query" (dispatch-query msg)
        "video" 
          (let [receiver (get-user (:receiver msg))]
            (enqueue (:channel receiver) (assoc (dissoc msg :ticket) :username username)))
        "logout" (logout-user user)
        (println "default action do nothing")
        ))))


;; message validators

(vali/defvalidator already-joined? "join"
                   [msg]
                   (when (contains? @(:users (get-chan (:chan-name msg))) (get-user (:username (:ticket msg))))
                     (str "Du bist schon im Chan " (:chan-name msg) ", Flasche!")))

(vali/defvalidator channel-exists? "join" 
  [msg]
  (when (nil? (get-chan (:chan-name msg)))
    (str "Der Channel " (:chan-name msg) " existiert nicht")))

(vali/defvalidator username-empty? "auth"
                   [msg]
                   (let [username (:username msg)]
                     (when (string/blank? username)
                       "The username cannot be empty.")))

(vali/defvalidator username-taken? "auth"
                   [msg]
                   (let [user (get-user (:username msg))]
                     (when (and (vali/not-nil? user) (:guest? @(:attr-map user)))
                       "The username is already taken.")))

(vali/defvalidator already-authed? "auth"
                   [msg]
                   (let [user (get-user (:username msg))]
                     (when (and (vali/not-nil? user) (not (:guest? @(:attr-map user))))
                       "Du Flasche bist schon authentifiziert")))

(vali/defvalidator self-video-call? "video"
                   [msg]
                   (when (= (:receiver msg) (:username (:ticket msg)))
                     "Du kannst dich nicht selber anrufen"))

(println "Registered validators:" @vali/validators)
