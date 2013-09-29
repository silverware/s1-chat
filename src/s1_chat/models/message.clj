(ns s1-chat.models.chat
  (:require [s1-chat.validation :as vali]
            [clojure.string :as string]
            [monger.collection :as mc]
            [s1-chat.controllers.login :as login-ctrl]
            )
  (:use aleph.formats lamina.core))

(load "chan")
(load "user")

(defn send-error [ch id text] (enqueue ch {:id id :type "error" :text text}))

(defn send-join-success [ch id chan]
  (enqueue ch {:id id :type "joinsuccess" :usernames (map #(:name %) @(:users chan)) :chan-name (:name chan) :anonymous (:anonymous? @(:attr-map chan))}))

(defn send-success [ch id payload]
  (enqueue ch {:id id :type "success" :payload payload}))

(defn remove-ticket [msg] (dissoc msg :ticket))

;; user to user query dispatch
(defn dispatch-query [{{username :username} :ticket :as original-msg}]
  (let [msg (assoc (remove-ticket original-msg) :username username)
        receivers (map get-user (:receivers msg))]
    (doseq [receiver receivers] (enqueue (:channel receiver) msg))))

;; auth message dispatch
(defn send-auth-success [ch session-id]
  (enqueue ch {:type "authsuccess" :session-id session-id}))

(defn dispatch-auth-msg [ch {:keys [id username password]} ]
  (let [session-id (auth ch username password)]
      (send-auth-success ch session-id)))

(defn dispatch-message
  [ch {id :id {:keys [username session-id]} :ticket :as msg}]
  (let [user (get-user username)]
    (if (valid-session-id? username session-id)
      (case (:type msg)
        "join" (let [dest-chan (get-chan (:chan-name msg))]
                 (add-user-to-chan user dest-chan)
                 (enqueue (:channel dest-chan) msg)
                 (send-join-success ch id dest-chan))
        "part" (let [chan (get-chan (:chan-name msg))]
                 (remove-user-from-chan user chan)
                 (send-part chan user))
        "query" (do
                  (dispatch-query msg)
                  (send-success ch id nil))
        "video"
          (let [receiver (get-user (:receiver msg))]
            (send-success ch id nil)
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


;; validators for auth
(vali/defvalidator username-empty? "auth"
                   [msg]
                   (let [username (:username msg)]
                     (when (and (string/blank? username) (not (:guest? msg)))
                       {:fieldErrors [[:login-username "The username cannot be empty."]]})))

(vali/defvalidator password-empty? "auth"
                   [msg]
                   (let [password (:password msg)]
                     (when (and (string/blank? password) (not (:guest? msg)))
                       {:fieldErrors [[:login-password "The password cannot be empty."]]})))

(vali/defvalidator password-incorrect? "auth"
                   [{:keys [password username guest?]}]
                     (when (and 
                             (zero? (mc/count "users" {:username username :password (login-ctrl/hash-password password)})) 
                             (not guest?))
                       (if (mc/any? "users" {:username username})
                         {:fieldErrors [[:login-password "Wrong password."]]}
                         {:fieldErrors [[:login-username "Username unknown jjk."]]})))

(vali/defvalidator already-authed? "auth"
                   [msg]
                   (let [user (get-user (:username msg))]
                     (when (and (vali/not-nil? user) (not (:guest? @(:attr-map user))))
                       "Du Flasche bist schon authentifiziert")))
;; guest-validation
(vali/defvalidator guest-username-empty? "auth"
                   [msg]
                   (let [username (:username msg)]
                     (when (and (string/blank? username) (:guest? msg))
                       {:fieldErrors [[:guest-username "The username cannot be empty."]]})))

(vali/defvalidator guest-username-taken? "auth"
                   [{:keys [username guest?]}]
                   (let [user (get-user username)]
                     (when (or
                             (vali/not-nil? user)
                             (and
                               (s1-chat.controllers.login/duplicate-username? username)
                               guest?))
                       {:fieldErrors [[:guest-username "The username is already in use."]]})))






;; validator for video
(vali/defvalidator self-video-call? "video"
                   [msg]
                   (when (= (:receiver msg) (:username (:ticket msg)))
                     "Du kannst dich nicht selber anrufen"))

;; message validators for query

(vali/defvalidator self-query? "query"
                   [{{sender :username} :ticket receivers :receivers :as msg}]
                   (when (some #{sender} receivers)
                     "You cannot query yourself."))

(vali/defvalidator query-receiver-exists? "query"
                   [{receivers :receivers :as msg}]
                   (let [invalid-receivers (filter (complement get-user) receivers)
                         joined-invalid-receivers (string/join ", " invalid-receivers)]
                     (when (seq invalid-receivers)
                       (if (= 1 (count invalid-receivers))
                         (str joined-invalid-receivers " is an unknown user.")
                         (str joined-invalid-receivers " are unknown users.")
                         ))))

(println "Registered validators:" @vali/validators)
