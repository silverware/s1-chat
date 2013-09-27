(defproject s1-chat "0.1.0-SNAPSHOT"
            :description "A high scalable real-time chat written in pure Clojure."
            :dependencies [[org.clojure/clojure "1.5.1"]
                           ;[noir "1.3.0-beta10"]
                           [aleph "0.3.0"]
                           [clj-coffee-script "1.1.0"]
                           [clj-json "0.5.3"]
                           [clj-time "0.6.0"]
                           [compojure "1.1.5"]
                           ;[crate "0.1.0-SNAPSHOT"]
                           [hiccup "1.0.2"]
                           [ring/ring-json "0.2.0"]
                           [ring/ring-jetty-adapter "1.1.0"]
                           [ring/ring-devel "1.1.0"]
                           [com.novemberain/monger "1.4.1"]
                           [org.clojure/test.generative "0.1.3"]
                           [lib-noir "0.3.5"]
                           [com.draines/postal "1.11.0"]
                           [org.clojure/tools.cli "0.2.4"]
                           ;[cheshire "2.2.0"]
                           ;[jayq "0.1.0-SNAPSHOT"]
                           ;[fetch "0.1.0-SNAPSHOT"]
                           [digest "1.3.0"]
                           ;[dieter/dieter "0.3.0"]
                           [com.cemerick/friend "0.1.3"]
                           ;[friend-oauth2 "0.0.2"]
                           ]
            ;:min-lein-version "2.0.0"
            :main s1-chat.handler
            :aot :all
            ;:eval-in-leiningen true
            :plugins [
                      [lein-cljsbuild "0.2.7"]
                      [lein-tarsier "0.9.1"]
                      [lein-ring "0.8.2"]
                      [lein-localrepo "0.4.1"]
                      ]
            :ring {:handler s1-chat.handler/app
                   :init s1-chat.server/ring-initializer}
            ;            :prep-tasks [["coffeescript" "resources/public/js" "src-cs"] "javac" "compile"]
            )

