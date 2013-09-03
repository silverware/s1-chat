(ns s1-chat.controllers.ajax
  (:require [monger.collection :as mc]
            [monger.conversion :as mconv]
            [monger.util :as mu]
            [monger.result :as mr]
            [noir.validation :as vali]
            [s1-chat.models.chat :as chat])
  (:use compojure.core
        ring.util.response
        s1-chat.validation
        ))

(defn convert-id [monger-object] 
  (let [doc-id (.toString (:_id (mconv/from-db-object monger-object true)))]
    (assoc (mconv/from-db-object monger-object true) :_id doc-id)))

(defn user-profile [username]
  (when-let [mongo-object (mc/find-one "users" {:username username})]
    (response (dissoc (convert-id mongo-object) :password))))

(defn valid-userprofile? [{:keys [email ]}]
  (vali/rule (vali/is-email? email) [:email "Invalid E-Mail Address."])
  )

(defn save-user-profile [{:keys [username] :as user} session-id]
  (let [response-map {:success false :fieldErrors nil :errors nil}]
    (when (chat/valid-session-id? username session-id)
      (if (valid-userprofile? user)
        (if (mr/has-error? (mc/update "users" {:username username} {"$set" (dissoc user :_id)} :upsert false))
          (response (assoc response-map :errors ["Error while updating the database."]))
          (response (assoc response-map :success true))
          )
        (response (assoc response-map :fieldErrors (json-errors :email)))
        ))))

(def ajax-routes [
                  (GET "/ajax/user/:username" [username] (user-profile username))
                  (POST "/ajax/user/" [user session-id] (save-user-profile user session-id))
                  ])
