(ns s1-chat.models.chat
  (:require [s1-chat.validation :as vali])
  (:use aleph.formats lamina.core))

(load "chan")

(defn send-error [ch text] (enqueue ch {:id 0 :type error :text text}))

(defn send-join-success [ch id usernames]
  (enqueue ch {:id id :type "joinsuccess" :usernames usernames}))

(defn send-auth-success [ch session-id]
  (enqueue ch {:type "authsuccess" :session-id session-id}))

(defn remove-ticket [msg] (dissoc msg :ticket))

(defn dispatch-query [{{username :username} :ticket :as original-msg}]
  (let [msg (assoc (remove-ticket original-msg) :username username) receivers (map get-user (:receivers msg))]
    (dorun (map #(enqueue (:channel %) msg) receivers)))) 

(defn dispatch-auth-msg [ch {:keys [username password]} ]
  (let [session-id (auth ch username password)]
    (send-auth-success ch session-id)))

(defn craft-public-msg [{{username :username} :ticket :as msg}] 
  "When a user writes into a Chan the message is siphoned into it.
  However, it needs to undergo modifications such as removal of the ticket.
  This function applies the necessary modifications."
  (if (nil? (:ticket msg))
    (assoc (remove-ticket msg) :id 0)
    (assoc (assoc (remove-ticket msg) :username username) :id 0)))

(defn add-user-to-chan
  [user dest-chan]
  (let [user-ch (:channel user)
        dest-ch (:channel dest-chan)
        users (:users dest-chan)
        bridge-ch (channel)
        bridge-ch2 (channel)]
    (println "Adding user " (:name user) " to chan " (:name dest-chan))
    (dosync 
      (alter users conj user)
      (alter (:chans user) assoc dest-chan (list bridge-ch bridge-ch2)))
    (siphon dest-ch bridge-ch2 user-ch)
    (siphon
      (filter* #(and (= (:chan-name %) (:name dest-chan)) (zero? (count (vali/validate %)))) user-ch)
      bridge-ch
      dest-ch)
    ))

(defn remove-user-from-chan
  [user chan]
  (dorun
	    (map #(close %) (@(:chans user) chan)))
		  (dosync 
		    (alter (:users chan) disj user)
		    (alter (:chans user) dissoc chan)))

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

(vali/defvalidator already-authed? "auth"
                   [msg]
                   (when (vali/not-nil? (get-user (:username msg)))
                     "Du Flasche bist schon authentifiziert"))

(vali/defvalidator self-video-call? "video"
                   [msg]
                   (when (= (:receiver msg) (:username (:ticket msg)))
                     "Du kannst dich nicht selber anrufen"))

(println "Registered validators:" @vali/validators)
