(ns s1-chat.handler
  (:gen-class)
  (:import [org.bson.types ObjectId])
  (:use compojure.core
        s1-chat.views.chat
        s1-chat.controllers.login
        s1-chat.server
        s1-chat.views.common
        s1-chat.server
        ring.middleware.json
        [ring.adapter.jetty :only [run-jetty]]
        noir.util.middleware)

  (:require [compojure.handler :as handler]
            [clojure.tools.cli]
            [compojure.route :as route]
            [s1-chat.controllers.login :as login-controller]
            [s1-chat.controllers.chan :as chan-controller]
            [s1-chat.controllers.ajax :as ajax-controller]
            [s1-chat.config :as cfg]
            [monger.collection :as mc]
            [cemerick.friend :as friend]
            [monger.core :as mg]
           ; [friend-oauth2.workflow :as oauth2]
            (cemerick.friend [workflows :as workflows]
                             [credentials :as creds])))



(def app-routes
  (concat
    login-controller/login-routes
    chan-controller/chan-routes
    ajax-controller/ajax-routes
    [
     

     (GET "/authlink" [] (friend/authorize #{::user} ("Authorized page.")))

     (route/resources "/")

     ; wildcard route, handled by ember
     (ANY "*" [] (chat))
     ]))

(defn my-credential-fn [{username :username password :password}]
  (if-let [user (mc/find-one-as-map "users" {:username username})]
    (do
      (if (= (login-controller/hash-password password) (:password user))
        {:identity username :roles #{::user}}
        nil))
    nil))

(def app
  (->
    (app-handler app-routes)
    (wrap-json-response)
    (wrap-json-body)
    (wrap-json-params)
    (friend/authenticate
      {
       :credential-fn my-credential-fn
       :workflows [(workflows/interactive-form)]})
    (handler/site)))

(defn generate-testdata []
  (mc/insert "users" {:_id (ObjectId.) :username "test" :email "test@example.com" :password (hash-password "test")}))

(defn setup-db []
  (connect-db)
  
  (mc/drop "users")
  (mc/ensure-index "users" { :email 1 } { :unique true })
  (mc/ensure-index "users" { :username 1 } { :unique true })

  (generate-testdata)

  (mg/disconnect!)

  (println "database 's1' created and collection 'users' generated")
)
(defn -main [& args]
  (let [[options args banner] (clojure.tools.cli/cli args
                                  ["-db" "--setup-db" "Create collections with sample data and indices." :default false :flag true]
                                  ["-h" "--help" "Show help" :default false :flag true]
                                  ["-c" "--config" "Path to properties file." :default "config.properties"])]
    (when (:help options)
      (println banner)
      (System/exit 0))
    (cfg/initialize-properties (:config options))
    (when (:setup-db options)
      (setup-db)
      (System/exit 0))
    (initialize-app)
    (run-jetty app {:port 5151})))
