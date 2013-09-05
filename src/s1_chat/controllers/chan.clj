(ns s1-chat.controllers.chan
  (:require [s1-chat.views.chat :as chat-view])
  (:use s1-chat.models.chat
        ring.util.response
        compojure.core))

(defn create-anon-chan []
  (dosync
    (loop [anon-chan (open-chan (str "Anonymous" @anon-chan-count) {:anonymous? true})]
      (if (nil? anon-chan)
        (do
          (alter anon-chan-count inc)
          (recur (open-chan (str "Anonymous" @anon-chan-count) {:anonymous? true})))
        (response {:chanName (:name anon-chan)})))))

(def chan-routes [
                  (POST "/chan/create" [] (create-anon-chan))
                  (GET "/chan/join/:chan-name" [chan-name] (chat-view/chat chan-name))
                  ])

