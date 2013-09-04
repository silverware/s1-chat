(ns s1-chat.chan-test
  (:require [monger.core :as mg])
  (:use lamina.core
        [s1-chat.models.chat]
        s1-chat.server
        clojure.test))

(defn db-fixture [f] 
  (mg/connect!)
  (mg/set-db! (mg/get-db "s1"))
  (f))

(use-fixtures :once db-fixture)

(def hans-channel (channel))

(def hans
  (->User "Hans Magic" hans-channel (ref #{}) (ref {:guest? true})))

(deftest create-chan-test
  (let [old-count (count @chans)]
    (create-chan :testchan)
    (is (= (inc old-count) (count @chans)))))

(deftest create-duplicate-chan-test
  (let [old-count (count @chans)]
    (create-chan :duplicatechan)
    (is (= (+ old-count 1) (count @chans)))
    (create-chan :duplicatechan)
    (is (= (+ old-count 1) (count @chans)))))



