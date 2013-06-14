(ns s1-chat.views.login
  (:require [noir.validation :as vali] 
            [s1-chat.views.common :as common]
            [monger.core :as mg]
            [monger.collection :as mc]
            [digest]
            [monger.result :as mr])
  (:use [hiccup.form]
        [hiccup.core :only [html]]
        compojure.response
        ))

(defn duplicate-email? [email]
  (mc/any? "users" {:email email}))

(defmacro if-user-exists [user then-clause else-clause]
      `(if (duplicate-email? (:email user))
        ~then-clause
        ~else-clause))

(defn valid-user? [{:keys [email username]}]
  (vali/rule (vali/is-email? email) [:email "Diese E-Mail-Adresse ist leider ungültig."])

  (vali/rule (not (duplicate-email? email)) [:email "Diese E-Mail-Adresse ist bei uns bereits registriert."])
  (not (vali/errors? :email)))

(defn register [{email :email username :username}]
  (common/layout
    (common/horizontal-form-to [:post ""]
                               (common/bootstrap-text-field :email "E-Mail" {:placeholder "name@example.com"} email )
                               (common/bootstrap-text-field :username "Username" username)
                               (common/bootstrap-text-field :password "password")
                               (common/bootstrap-submit "Submit"))))


(defn hash-password [password-string]
  (digest/sha-256 password-string))

(defn register-post [user]
  (if (valid-user? user)
    (if (mr/has-error? 
          (mc/insert "users" 
                     {:email (:email user)
                      :password (hash-password (:password user))
                      :username (:username user)}))
      (println "error while inserting user")
      (println "insert success"))
     (register user)))
      

(defn login []
  (common/layout
    (common/horizontal-form-to [:post "/login"]
                               (common/bootstrap-text-field :username "username" {:placeholder "name@example.com"})
                               (common/bootstrap-text-field :password "Password")
                               (common/bootstrap-submit "Submit"))))
