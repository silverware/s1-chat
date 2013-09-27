(ns s1-chat.server
  (:require 
    [monger.core :as mg]
    [aleph.formats :as formats]
    [s1-chat.config])

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
    #(let [msg % _type (:type msg) id (:id msg)]
       (println (str "Message:" msg))
       (if (not (empty? (validate msg)))
         (do 
           (println "Errors: " (validate msg))
           (doall (map (fn [error-text] (send-error json-ch id error-text)) (validate msg))))
         (if (= _type "auth")
           (dispatch-auth-msg json-ch msg)
           (dispatch-message json-ch msg)))))))

(defn connect-db []
  (println "==========================")
  (println "  CONNECTING TO DATABASE  ")
  (println "==========================")
  (mg/connect! {:port (:mongodb-port properties)} )
  (mg/set-db! (mg/get-db "s1")))


(defn initialize-app []
  (connect-db)
  (println "==========================")
  (println "STARTING WEBSOCKET-SERVEUR")
  (println "==========================")
  (start-http-server chat-handler {:port 8008 :websocket true}))

(defn ring-initializer [] 
  (s1-chat.config/initialize-properties "config.properties")
  (initialize-app))
