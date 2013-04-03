(ns s1-chat.models.chat
  (:use lamina.core aleph.formats s1-chat.models.user))

;(declare remove-ticket)

(def chans (ref {}))
(def anon-chan-count(ref 0))

(defrecord Chan [name channel users props])

(declare craft-public-msg)
(defn secure-channel [ch]
  (splice 
    (map* craft-public-msg ch)
    ch))

(defn create-chan
  ([name] (create-chan name {}))
  ([name & props]
   (dosync 
     (let [ch (secure-channel (channel)) chan (Chan. name ch (ref #{}) props)]
       (if (not (@chans name))
         (do 
           (alter chans assoc name chan)
           chan)
         nil)
       ))))

(defn create-default-chans [] 
  (let [default-chans ["Gefahr" "Hans" "Test"]]
    (doseq [chan default-chans] (create-chan chan))))

(defn get-chan [^String chan-name]
  (@chans chan-name))

