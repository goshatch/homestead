(defpackage homestead/tests/main
  (:use :cl
        :homestead
        :fiveam)
  (:export #:run! #:all-tests))
(in-package #:homestead/tests/main)

;; NOTE: To run this test file, execute `(asdf:test-system :homestead)' in your Lisp.

(def-suite all-tests
  :description "Global test suite")

(in-suite all-tests)

(defun test-homestead ()
  (run! 'all-tests))

(test dummy-tests
  "Just a placeholder."
  (is (listp (list 1 2)))
  (is (= 5 (+ 2 3))))
