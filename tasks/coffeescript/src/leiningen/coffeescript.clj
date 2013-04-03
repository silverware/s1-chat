(ns leiningen.coffeescript
  (:use [clojure.java.shell :only [sh]]))

(defn coffeescript
  "Compile coffeescript files."
  [project & args]
  (let [output-dir (first args) input-dir (second args)]
    (sh "coffee" (str "--watch --compile -o " output-dir " " input-dir))))
