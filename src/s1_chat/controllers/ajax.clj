(ns s1-chat.controllers.ajax
  (:require [monger.collection :as mc]
            [monger.conversion :as mconv]
            [monger.util :as mu]
            [s1-chat.models.chat :as chat])
  (:use compojure.core
        ring.util.response
        ))

(defn convert-id [monger-object] 
  (let [doc-id (.toString (:_id (mconv/from-db-object monger-object true)))]
    (assoc (mconv/from-db-object monger-object true) :_id doc-id)))

(defn user-profile [username]
  (when-let [mongo-object (mc/find-one "users" {:username username})]
    (response (dissoc (convert-id mongo-object) :password))))

(defn save-user-profile [{:keys [username] :as user} session-id]
  (when (chat/valid-session-id? username session-id)
    (mc/update "users" {:username username} {"$set" (dissoc user :_id)} :upsert false)
    (response {:success true})))

(def ajax-routes [
                  (GET "/ajax/user/:username" [username] (user-profile username))
                  (POST "/ajax/user/" [user session-id] (save-user-profile user session-id))
                  ])
