(ns s1-chat.server
  (:require 
    [monger.core :as mg]
    [aleph.formats :as formats])
  (:use [aleph.http] 
        [lamina.core]
        [s1-chat.models.chat]
        [s1-chat.validation]))

(defn decode-json-channel [ch] 
  (map* formats/decode-json  ch))

(defn encode-json-channel [target-ch]
  (let [ch (channel)]
    (siphon (map* formats/encode-json->string ch) target-ch)
    ch))

(defn wrap-json-channel [ch]
    (splice
      (decode-json-channel ch)
      (encode-json-channel ch)))

(defn chat-handler [ch handshake] 
  (let [json-ch (wrap-json-channel ch)] 
  (receive-all json-ch 
    #(let [msg % _type (:type msg)]
       (println (str "Message:" msg))
       (if (not (empty? (validate msg)))
         (println "Errors: " (validate msg))
         (if (= _type "auth")
           (dispatch-auth-msg json-ch msg)
           (dispatch-message json-ch msg)))))))

;(server/load-views "src/s1_chat/views/")

(defn initialize-app []
  (println "==========================")
  (println "  CONNECTING TO DATABASE  ")
  (println "==========================")
  (mg/connect!)
  (mg/set-db! (mg/get-db "s1"))
  (println "==========================")
  (println "STARTING WEBSOCKET-SERVEUR")
  (println "==========================")
  (create-default-chans)
  (start-http-server chat-handler {:port 8008 :websocket true}))

