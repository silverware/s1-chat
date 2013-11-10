(ns s1-chat.controllers.ajax
  (:require [monger.collection :as mc]
            [monger.conversion :as mconv]
            [monger.util :as mu]
            [monger.result :as mr]
            [noir.validation :as vali]
            [clj-time.core :as clj-time]
            [monger.gridfs :as gfs]
            [s1-chat.controllers.login :as lc]
            [s1-chat.models.chat :as chat])
  (:use compojure.core
        ring.util.response
        s1-chat.validation
        [image-resizer.core :only [crop-from resize]]
        )
  (:import (org.joda.time IllegalFieldValueException)))

(defn valid-ticket? [{:keys [username session-id]}]
  (chat/valid-session-id? username session-id))

(defn convert-id [monger-object]
  (let [doc-id (.toString (:_id (mconv/from-db-object monger-object true)))]
    (assoc (mconv/from-db-object monger-object true) :_id doc-id)))

(defn user-profile [username]
  (if-let [mongo-object (mc/find-one "users" {:username username})]
    (response (dissoc (convert-id mongo-object) :password))
    (not-found "user not found")))

(defn user-image [username]
  (if-let [image (gfs/find-one {:filename (str "/image/" username)})]
    (response (.getInputStream image))
    (redirect "/img/dummy.png")
    ))

(defn create-birthdate [year month day]
  (.toDate (clj-time/date-time (read-string year) (read-string month) (read-string day))))

(defn valid-date? [year month day]
  (if (every? clojure.string/blank? [year month day])
    true
    (try (create-birthdate year month day) true
      (catch Exception e 
        (.printStackTrace e) 
        false))))

(defn valid-userprofile? [{:keys [email birthdate-day birthdate-month birthdate-year]}]
  (vali/rule (vali/is-email? email) [:email "Invalid E-Mail Address."])
  (vali/rule (valid-date? birthdate-year birthdate-month birthdate-day) [:birthdate "Invalid birthdate."])
  (not (vali/errors? :birthdate :email)))

(defn add-birthdate [{:keys [birthdate-day birthdate-month birthdate-year] :as user}]
  (assoc (dissoc user :birthdate-day :birthdate-month :birthdate-year) :birthdate 
           (if (every? clojure.string/blank? [birthdate-year birthdate-month birthdate-day])
             nil
             (create-birthdate birthdate-year birthdate-month birthdate-day))))

(defn save-user-profile [user username]
  (let [response-map {:success false :fieldErrors nil :errors nil}]
    (if (valid-userprofile? user)
      
      (if (mr/has-error? (mc/update "users" {:username username} {"$set" (add-birthdate user)} :upsert false))
        (response (assoc response-map :errors ["Error while updating the database."]))
        (response (assoc response-map :success true))
        )
      (response (assoc response-map :fieldErrors (json-errors :email :birthdate)))
      )))


(defn valid-password-form? [{:keys [password-old password1 password2]} username]
  (vali/rule (lc/valid-old-password? username password-old) [:password-old "Old password does not match"])
  (vali/rule (lc/valid-passwords? password1 password2) [:password1 "Die Passwörter stimmen nicht überein."])
  (not (vali/errors? :password-old :password1)))

(defn change-password [{:keys [password-old password1 password2] :as form} username]
  (let [response-map {:success false :fieldErrors nil :errors nil}]
      (if (valid-password-form? form username)
        (if (mr/has-error? (mc/update "users" {:username username} {"$set" {:password (lc/hash-password password1)}} :upsert false))
          (response (assoc response-map :errors ["Error while updating the database."]))
          (response (assoc response-map :success true))
          )
        (response (assoc response-map :fieldErrors (json-errors :password1 :password-old)))
        )))

(defn save-image [username image [x y wh]]
  (let [file-name (str "/image/" username)] 
    (println (get image :tempfile))
    (println image)
    (println x y wh)
    (println (resize (get image :tempfile) 12 12))
    (gfs/remove {:filename file-name})
    (gfs/store-file (gfs/make-input-file (get image :tempfile)) ;(crop-from x y wh wh))(get image :tempfile)
                (gfs/filename file-name))))


(defn public-chans [] (response (map second (for [[k v] (select-keys @chat/chans (for [[k v] @chat/chans :when (not (:anonymous? @(:attr-map v)))] k))] [k (dissoc (assoc v :users (count @(:users v))) :channel :attr-map)] ))))

(def ajax-routes [
                  (GET "/ajax/user/:username" [username] (user-profile username))
                  (GET "/ajax/chans" [] (public-chans))
                  (POST "/ajax/user/" [form ticket] (when (valid-ticket? ticket) (save-user-profile form (:username ticket))))
                  (POST "/ajax/user/password" [ticket form] (when (valid-ticket? ticket) (change-password form (:username ticket))))
                  (POST "/ajax/user/geolocation" [ticket position] (when (valid-ticket? ticket) (chat/append-attr (:username ticket) :geo position)))
                  (POST "/ajax/user/image" [username session-id image x y wh] (when (chat/valid-session-id? username session-id) (save-image username image [x y wh])))
                  (GET "/ajax/user/:username/image" [username] (user-image username))
                  ])
