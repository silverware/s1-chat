(ns s1-chat.views.chat  
  (:require [s1-chat.views.common :as common])
  (:use [hiccup.page :only [include-css include-js html5]]))

(defn chat []
  (common/layout
    (include-css "/css/chat.css")
    [:script "require(['chat/chat'], function(ChatApp) {window.Chat = ChatApp.create()});"]
))



