(ns s1-chat.validation
  (:require [noir.validation :as vali]))

(defn json-errors [& fields]
    (remove (comp nil? second) (reduce #(conj %1 [%2 (vali/get-errors %2)]) []  fields)))

(def not-nil? (comp not nil?)) 

(defmacro if-error [pred on-error & body] 
  `(if-not ~pred 
     ~on-error
     (do ~@body)))

(defonce validators (ref {}))

(defn validate [{t :type :as msg}] 
  (let [v (@validators t)]
    (let [errors (filter not-nil? (map #(let [f % text (try
                                            (f msg)
                                            (catch NullPointerException e nil))]
                             (when (not-nil? text)
                               text)) v))]
      errors)))

(defn add-validator [msg-type fun] 
  (dosync 
    (alter validators 
           (fn [m f] (assoc m msg-type (conj (m msg-type) f))) 
           fun)))

(defmacro defvalidator [n _type & fdecl]
  `(do 
     (declare ~n)
     (defn ~n ~@fdecl)
     (require 's1-chat.validation)
     (add-validator ~_type ~n)
     ))
