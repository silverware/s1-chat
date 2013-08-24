(ns s1-chat.controllers.chan
  (:use s1-chat.views.chan
        s1-chat.models.chat
        compojure.core))

(defn create-anon-chan-post []
  (dosync
    (loop [anon-chan (create-chan (str "Anonymous " @anon-chan-count) {:anonymous? true})]
      (if (nil? anon-chan)
        (do 
          (alter anon-chan-count inc)
          (recur (create-chan (str "Anonymous " @anon-chan-count))))
        (show-anon-chan-url anon-chan)))))

(def chan-routes [
                  (POST "/chan/create" [] (create-anon-chan-post))
                  (GET "/chan/join/:chan-name" [chan-name] (join-anon-chan chan-name))
                  (GET "/chan/create" [] (create-anon-chan))
                  ])

