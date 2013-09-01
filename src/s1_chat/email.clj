(ns s1-chat.email
  (:require [s1-chat.config :as cfg])
  (:use postal.core))

(defn send-email [to subject text]
  (send-message ^{:host (:smtp-host cfg/properties)
                  :user (:smtp-user cfg/properties)
                  :pass (:smtp-password cfg/properties)
                  :ssl (:smtp-use-ssl cfg/properties)}
                {
                 :from (:email-sender cfg/properties)
                 :to to
                 :subject subject
                 :body text}
                ))


