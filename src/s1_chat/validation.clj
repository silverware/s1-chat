(ns s1-chat.validation)

(def not-nil? (comp not nil?)) 

(defmacro if-error [pred on-error & body] 
  `(if-not ~pred 
     ~on-error
     (do ~@body)))

(defonce validators (ref {}))

(defn validate [{t :type :as msg}] 
  (let [v (@validators t)]
    (filter not-nil? (map #(let [f % text (try
                                            (f msg)
                                            (catch NullPointerException e nil))]
                             (when (not-nil? text)
                               text)) v))))

(defn add-validator [msg-type fun] 
  (dosync 
    (alter validators 
           (fn [m f] (assoc m msg-type (conj (m msg-type) f))) 
           fun)))

(defmacro defvalidator [n _type & fdecl]
  `(do 
     (declare ~n)
     (defn ~n ~@fdecl)
     (add-validator ~_type ~n)
     ))
