(ns s1-chat.models.chat
  (:use lamina.core aleph.formats))

(defrecord Chan [name channel users attr-map])
(declare craft-public-msg)
(defn secure-channel [ch]
  (splice 
    (map* craft-public-msg ch)
    ch))
(defn make-chan 
  ([name] (make-chan name {}))
  ([name attr-map] 
   (let [chan (Chan. name (secure-channel (permanent-channel)) (ref #{}) (ref attr-map))]
     (siphon (:channel chan) (permanent-channel)) ; workaround to prevent chan's channel from draining
     chan)))

(def default-chans ["Gefahr" "Hans" "Test"])
(def chans (ref (zipmap default-chans (map make-chan default-chans))))
(def anon-chan-count (ref 0))

(defn open-chan
  ([name] (open-chan name {}))
  ([name attr-map]
   (dosync 
     (let [chan (make-chan name attr-map)]
       (if (not (@chans name))
         (do 
           (alter chans assoc name chan)
           chan)
         nil)
       ))))

(defn get-chan [^String chan-name]
  (@chans chan-name))

(declare remove-ticket)
(defn craft-public-msg [{{username :username} :ticket :as msg}] 
  "When a user writes into a Chan the message is siphoned into it.
  However, it needs to undergo modifications such as removal of the ticket.
  This function applies the necessary modifications."
  (if (nil? (:ticket msg))
    (assoc (remove-ticket msg) :id 0)
    (assoc (assoc (remove-ticket msg) :username username) :id 0)))

(defn add-user-to-chan
  [user dest-chan]
  (let [user-ch (:channel user)
        dest-ch (:channel dest-chan)
        users (:users dest-chan)
        bridge-ch (channel)
        bridge-ch2 (channel)]
    (println "Adding user " (:name user) " to chan " (:name dest-chan))
    (dosync 
      (alter users conj user)
      (alter (:chans user) assoc dest-chan (list bridge-ch bridge-ch2)))
    (siphon dest-ch bridge-ch2 user-ch)
    (siphon
      (filter* #(and (= (:chan-name %) (:name dest-chan)) (zero? (count (vali/validate %)))) user-ch)
      bridge-ch
      dest-ch)
    ))

(defn remove-user-from-chan
  [user chan]
  (dorun
    (map #(close %) (@(:chans user) chan)))
  (dosync 
    (alter (:users chan) disj user)
    (alter (:chans user) dissoc chan))
  (println (:name user) " left chan " (:name chan)))
