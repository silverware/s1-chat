(ns s1-chat.views.login
  (:require 
            [s1-chat.views.common :as common])
  (:use [hiccup.form]
        [hiccup.core :only [html]]
        compojure.response
        ))

(defn register [{email :email username :username}]
  (common/layout
    (common/horizontal-form-to [:post ""]
                               (common/bootstrap-text-field :email "E-Mail" {:placeholder "name@example.com"} email )
                               (common/bootstrap-text-field :username "Username" username)
                               (common/bootstrap-password-field :password "password")
                               (common/bootstrap-password-field :password "password (repeat)")
                               (common/bootstrap-submit "Submit"))))

(defn login []
  (common/layout
    (common/horizontal-form-to [:post "/login"]
                               (common/bootstrap-text-field :username "username" {:placeholder "name@example.com"})
                               (common/bootstrap-password-field :password "Password")
                               (common/bootstrap-submit "Submit"))))
