(ns s1-chat.controllers.login 
  (:use aleph.formats
        compojure.core
        ring.util.response
        s1-chat.validation)
  (:require [s1-chat.views.login :as vl]
            [monger.collection :as mc]
            [noir.validation :as vali]  
            [monger.core :as mg]
            [digest]
            [monger.result :as mr]))

(defn hash-password [password-string]
  (digest/sha-256 password-string))

(defn duplicate-email? [email]
  (mc/any? "users" {:email email}))

(defn duplicate-username? [username]
  (mc/any? "users" {:username username}))

(defn valid-passwords? [password1 password2]
  (and (= password1 password2) (not (empty? password1))))

(defmacro if-user-exists [user then-clause else-clause]
  `(if (duplicate-email? (:email user))
     ~then-clause
     ~else-clause))

(defn valid-user? [{:keys [email username password1 password2]}]
  (vali/rule (vali/is-email? email) [:email "Diese E-Mail-Adresse ist leider ungültig."])

  (vali/rule (not (duplicate-email? email)) [:email "Diese E-Mail-Adresse ist bei uns bereits registriert."])

  (vali/rule (not (duplicate-username? username)) [:username "Username is not available."])

  (vali/rule (valid-passwords? password1 password2) [:password1 "Die Passwörter stimmen nicht überein."])

  (vali/rule (#(not (empty? username))) [:username "Benutzername darf nicht leer sein."])
  (not (vali/errors? :email :password1 :username)))

(defn register [user] (vl/register user))

(defn register-post [user]
  (if (valid-user? user)
    (if (mr/has-error? (mc/insert "users" 
                     {:email (:email user)
                      :password (hash-password (:password1 user))
                      :username (:username user)}))
      (response {:errors ["Error while inserting into database."]})
      (response {:success true}))
    (response {:fieldErrors (json-errors :email :password1 :username)})))

(def login-routes [
             (GET "/register" {{:as user} :params} (register user))
             (POST "/register" {{:as user} :params} (register-post user))
             (GET "/login" [] (vl/login))
             ])
