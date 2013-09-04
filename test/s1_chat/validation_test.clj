(ns s1-chat.validation-test
  (:require [s1-chat.controllers.ajax :as ajax])
  (:use clojure.test))


(deftest date-validator-test
         (is (= (ajax/valid-date? 1989 6 17) true))
         (is (= (ajax/valid-date? 1989 13 17) false))
         (is (= (ajax/valid-date? 1989 6 32) false))
         )
