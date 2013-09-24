(ns s1-chat.views.chat
  (:use [hiccup.page :only [include-css include-js html5]])
  (:require [s1-chat.views.common :as common]))

(defn chat []
    (common/layout))



