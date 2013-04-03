(ns chat.chat-client
   (:require [jayq.core :as jq] [goog.net.WebSocket :as ws]))

;(js/alert "Hello world!") 

;(def ws (. jquery gracefulWebSocket "ws://localhost:8008/"))

(defn initChat [chatId]
	(def websocket (goog.net.WebSocket.))
	(.open websocket "ws://localhost:8008/")
	
	(jq/bind (jq/$ :#sendchat) :submit (fn [event]
  (js/alert "huhu")
                                      
	  (.preventDefault event)
                                 
	  (.send websocket (jq/val "#msg")))
	))

(defn huhu []
  (js/alert "huhu"))


;(def ws (. jquery websocket "ws://localhost:8008/"))
;(js/setTimeout (fn [] 
;(.send ws "Marvin")
;(.send ws "hi")
;(.send ws "puppe")
;) 1000)


;(defn auth []
;  (let[au (js-obj "name" "test" "password" "pass")]
;    ))
;
;(set! (.-onmessage ws) (fn [event]
;  (.append (jquery "#channel") (str (.-data event) "<br />"))))
;(.ready (jquery) #( 
;

