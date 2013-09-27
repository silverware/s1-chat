(ns s1-chat.config
  (:require clojure.java.io))

(defn -load-props
    [file-name]
    (with-open [^java.io.Reader reader (clojure.java.io/reader file-name)] 
          (let [props (java.util.Properties.)]
                  (.load props reader)
                  (into {} (for [[k v] props] [(keyword k) (read-string v)])))))

(def properties nil)

(defn initialize-properties 
  [file-name] (def properties (-load-props file-name)))

