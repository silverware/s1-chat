(ns s1-chat.handler
  (:use compojure.core
        s1-chat.views.chat
        s1-chat.views.common
        s1-chat.views.login
        s1-chat.views.templates.chat
        s1-chat.views.chan
        s1-chat.server
        [ring.adapter.jetty :only [run-jetty]]
        noir.util.middleware)

  (:require [compojure.handler :as handler]
            [compojure.route :as route]
            [s1-chat.controllers.login :as login-controllers]
            [s1-chat.controllers.chan :as chan-controllers]
            [monger.collection :as mc]
            [cemerick.friend :as friend]
            [monger.core :as mg]
           ; [friend-oauth2.workflow :as oauth2]
            (cemerick.friend [workflows :as workflows]
                             [credentials :as creds])))


;;;;;;;;;;;;;;;;;;;;;
;; FACEBOOK OAUTH  ;;
;;;;;;;;;;;;;;;;;;;;;

; (defn access-token-parsefn
;   [response]
;   ((clojure.walk/keywordize-keys
;      (ring.util.codec/form-decode
;        (response :body))) :access_token))
; 
; (def config-auth {:roles #{::user}})
; 
; (def client-config
;   {:client-id "559686530710205"
;    :client-secret "2e2035bd9e17f07c7398e85807dbb7ce"
;    :callback {:domain "http://localhost:3000" :path "/facebookcallback"}})
; 
; (def uri-config
;   {:authentication-uri {:url "https://www.facebook.com/dialog/oauth"
;                         :query {:client_id (:client-id client-config)
;                                 :redirect_uri (oauth2/format-config-uri client-config)}}
; 
;    :access-token-uri {:url "https://graph.facebook.com/oauth/access_token"
;                       :query {:client_id (:client-id client-config)
;                               :client_secret (:client-secret client-config)
;                               :redirect_uri (oauth2/format-config-uri client-config)
;                               :code ""}}})
; 

(def app-routes
  (clojure.set/union
    login-controllers/login-routes
    chan-controllers/chan-routes
    [
     (GET "/" [] (chat))
     (GET "/chat" [] (chat))

     ; template routing
     (GET "/chat_template.hbs" [] (hbs-chat-template))
     (GET "/query_stream_template.hbs" [] (hbs-query-stream-template))
     (GET "/chan_template.hbs" [] (hbs-chan-template))
     (GET "/chan_users_template.hbs" [] (hbs-chan-users-template))
     (GET "/home_template.hbs" [] (hbs-home-template))
     (GET "/login_template.hbs" [] (hbs-login-template))

     ;; (GET "/facebookcallback" [] (do
     ;;                                   (println "huhu")
     ;;                                   (str "huhu")))

     (GET "/authlink" [] (friend/authorize #{::user} ("Authorized page.")))

     (route/resources "/")
     ]))

(defn my-credential-fn [{username :username password :password}]
  (if-let [user (mc/find-one-as-map "users" {:username username})]
    (do 
      (if (= (login-controllers/hash-password password) (:password user))
        {:identity username :roles #{::user}} 
        nil))
    nil))

(def app 
  (-> 
    (app-handler app-routes)
    (friend/authenticate 
      {
       :credential-fn my-credential-fn
       :workflows [(workflows/interactive-form)]})
    (handler/site)))

(defn -main []
  (initialize-app)
  (run-jetty app {:port 5151}))
