(ns s1-chat.controllers.ajax
  (:require [monger.collection :as mc]
            [monger.conversion :as mconv]
            [monger.util :as mu]
            [monger.result :as mr]
            [noir.validation :as vali]
            [clj-time.core :as clj-time]
            [s1-chat.models.chat :as chat])
  (:use compojure.core
        ring.util.response
        s1-chat.validation
        )
  (:import (org.joda.time IllegalFieldValueException)))

(defn convert-id [monger-object]
  (let [doc-id (.toString (:_id (mconv/from-db-object monger-object true)))]
    (assoc (mconv/from-db-object monger-object true) :_id doc-id)))

(defn user-profile [username]
  (if-let [mongo-object (mc/find-one "users" {:username username})]
    (response (dissoc (convert-id mongo-object) :password))
    (not-found "user not found")))

(defn valid-date? [year month day]
  (try (clj-time/date-time year month day) true
    (catch IllegalFieldValueException e false)))

(defn valid-userprofile? [{:keys [email birthday-day birthday-month birthday-year]}]
  (vali/rule (vali/is-email? email) [:email "Invalid E-Mail Address."])
  ;(vali/rule (valid-date? birthday-year birthday-month birthday-day) [:birthdate "Invalid birthdate."])
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


(defn change-password [username session-id]
  (let [response-map {:success false :fieldErrors nil :errors nil}]
    (when (chat/valid-session-id? username session-id)
      )))


(defn public-chans [] (response (map second (for [[k v] (select-keys @chat/chans (for [[k v] @chat/chans :when (not (:anonymous? @(:attr-map v)))] k))] [k (dissoc (assoc v :users (count @(:users v))) :channel :attr-map)] ))))

(def ajax-routes [
                  (GET "/ajax/user/:username" [username] (user-profile username))
                  (GET "/ajax/chans" [] (public-chans))
                  (POST "/ajax/user/" [user session-id] (save-user-profile user session-id))
                  (POST "/ajax/user/password" [old-password new-password username session-id] (change-password username session-id))
                  ])
