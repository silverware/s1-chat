(ns leiningen.setup-db
  "Setup MongoDb."
  (:require [monger.core :as mg]
            [monger.collection :as mc])
  (:import [org.bson.types ObjectId]))

(defn generate-testdata []
  (mc/insert "users" {:_id (ObjectId.) :name "John"}))


(defn setup-db [args]
  ;; connect without authentication
  ;; localhost, default port
  (mg/connect!)
  (mg/set-db! (mg/get-db "s1"))

  (mc/drop "users")
  (generate-testdata)
  (mc/ensure-index "users" { :email 1 } { :unique true })
  (mc/ensure-index "users" { :username 1 } { :unique true })

  (mg/disconnect!)

  (println "database 's1' created and collection 'users' generated")
)
