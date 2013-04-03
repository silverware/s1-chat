(ns s1-chat.views.chan
  (:use s1-chat.models.chat)
  (:require [s1-chat.views.common :as common]))

(defn create-anon-chan []
  (common/layout 
    (common/horizontal-form-to [:post ""] (common/bootstrap-submit "Create anonymous Channel"))))

(defn show-anon-chan-url [chan]
  (let [join-url (format "http://localhost:3000/chan/join/%s" (:name chan))]
  (common/layout 
    [:input 
     {:type "textfield" 
      :value join-url}]
    [:a {:href join-url} "Join"])))

(defn create-anon-chan-post []
  (dosync
    (loop [anon-chan (create-chan (str "Anonymous " @anon-chan-count))]
      (if (nil? anon-chan)
        (do 
          (alter anon-chan-count inc)
          (recur (create-chan (str "Anonymous " @anon-chan-count))))
        (show-anon-chan-url anon-chan)))))

(defn join-anon-chan [chan-name]
  (common/layout
    ;(include-css "/css/chat.css")
    [:script (format "require(['chat/chat'], function(Chat) 
             {
             window.chat = Chat.create({
             containerId: 'channel',
             initialChan: '%s' 
             });
             });" chan-name)]
    [:div#login] 
    [:div#channel]
))
