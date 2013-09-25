(ns leiningen.setup-db
  "Create s1 databases and fill with test data."
  (:use s1-chat.controllers.login
        s1-chat.server)
  (:require [monger.core :as mg]
            [monger.collection :as mc])
  (:import [org.bson.types ObjectId]))

(defn generate-testdata []
  (mc/insert "users" {:_id (ObjectId.) :username "test" :email "test@example.com" :password (hash-password "test")}))


(defn setup-db [args]
  ;; connect without authentication
  ;; localhost, default port
  (connect-db)
  
  (mc/drop "users")
  (mc/ensure-index "users" { :email 1 } { :unique true })
  (mc/ensure-index "users" { :username 1 } { :unique true })

  (generate-testdata)

  (mg/disconnect!)

  (println "database 's1' created and collection 'users' generated")
)
