(ns s1-chat.chan-test
  (:use lamina.core
        [s1-chat.models.chat]
        s1-chat.server
        clojure.test))

(def hans-channel (channel))

(def hans
  (->User "Hans Magic" hans-channel (ref #{})))

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




