(defpackage homestead/tests/util
  (:use :cl :fiveam)
  (:export :util-test-suite :|util-test-suite|))

(in-package :homestead/tests/util)

(def-suite
  util-test-suite
  :description "Util test suite"
  :in homestead/tests:all-tests)
(in-suite util-test-suite)

(test join
  (let ((list '("a" "b")))
    (is (string= (homestead/util:join list) "a, b"))
    (is (string= (homestead/util:join list " | ") "a | b"))))

(test slurp
  (let ((missing-file "/tmp/bob.txt"))
    (is (equal '() (homestead/util:slurp missing-file)))))
