(ns s1-chat.controllers.login
  (:use aleph.formats
        compojure.core
        ring.util.response
        s1-chat.validation)
  (:require [s1-chat.email :as email]
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

(defn valid-old-password? [username password]
  (mc/any? "users" {:username username :password (hash-password password)}))

(defmacro if-user-exists [user then-clause else-clause]
  `(if (duplicate-email? (:email ~user))
     ~then-clause
     ~else-clause))

(defn valid-user? [{:keys [email username password1 password2]}]
  (vali/rule (vali/is-email? email) [:email "Diese E-Mail-Adresse ist leider ungültig."])

  (vali/rule (not (duplicate-email? email)) [:email "Diese E-Mail-Adresse ist bei uns bereits registriert."])

  (vali/rule (not (duplicate-username? username)) [:username "Username is not available."])

  (vali/rule (valid-passwords? password1 password2) [:password1 "Die Passwörter stimmen nicht überein."])

  (vali/rule (#(not (empty? username))) [:username "Benutzername darf nicht leer sein."])
  (not (vali/errors? :email :password1 :username)))

(defn register-post [user]
  (let [response-map {:success false :errors nil :fieldErrors nil}]
    (if (valid-user? user)
      (if (mr/has-error? (mc/insert "users"
                                    {:email (:email user)
                                     :password (hash-password (:password1 user))
                                     :username (:username user)}))
        (response (assoc response-map :errors ["Error while inserting into database."]))
        (response (assoc response-map :success true)))
      (response (assoc response-map :fieldErrors (json-errors :email :password1 :username))))))

(def login-routes [
             (POST "/register" {{:as user} :params} (register-post user))
             ])
