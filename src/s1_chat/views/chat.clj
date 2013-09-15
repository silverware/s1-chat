(ns s1-chat.views.chat
  (:use [hiccup.page :only [include-css include-js html5]])
  (:require [s1-chat.views.common :as common]))

(defn chat
  ([] (chat (str "")))
  ([initial-chan]
    (common/layout
      (include-css "/css/chat.css")
      [:script (format "Chat = Chat.create({initialChan: '%s'});" initial-chan)]
)))



