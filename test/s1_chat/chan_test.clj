(ns s1-chat.chan-test
  (:require [s1-chat.models.chat :as chan])
  (:use lamina.core
        s1-chat.models.user
        s1-chat.server
        clojure.test))

(def hans-channel (channel))

(def hans
  (->User "Hans Magic" hans-channel (ref #{})))

(deftest create-chan-test
  (let [old-count (count @chan/chans)]
    (chan/create-chan :testchan)
    (is (= (inc old-count) (count @chan/chans)))))

(deftest create-duplicate-chan-test
  (let [old-count (count @chan/chans)]
    (chan/create-chan :duplicatechan)
    (is (= (+ old-count 1) (count @chan/chans)))
    (chan/create-chan :duplicatechan)
    (is (= (+ old-count 1) (count @chan/chans)))))




