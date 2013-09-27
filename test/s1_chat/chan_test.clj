(ns s1-chat.chan-test
  (:require 
    [monger.core :as mg]
    [s1-chat.config])
  (:use lamina.core
        [s1-chat.models.chat]
        s1-chat.server
        clojure.test))

(defn db-fixture [f] 
  (s1-chat.config/initialize-properties "config.properties")
  (connect-db)
  (f))

(use-fixtures :once db-fixture)

(def hans-channel (channel))

(def hans
  (->User "Hans Magic" hans-channel (ref #{}) (ref {:guest? true})))

(deftest open-chan-test
  (let [old-count (count @chans)]
    (open-chan :testchan)
    (is (= (inc old-count) (count @chans)))))

(deftest create-duplicate-chan-test
  (let [old-count (count @chans)]
    (open-chan :duplicatechan)
    (is (= (+ old-count 1) (count @chans)))
    (open-chan :duplicatechan)
    (is (= (+ old-count 1) (count @chans)))))



