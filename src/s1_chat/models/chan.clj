(ns s1-chat.models.chat
  (:use lamina.core aleph.formats))

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

(defn get-chan [^String chan-name]
  (@chans chan-name))

(defn create-default-chans [] 
  (let [default-chans ["Gefahr" "Hans" "Test"]]
    (doseq [chan default-chans] (create-chan chan))))

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
    (alter (:chans user) dissoc chan)))
