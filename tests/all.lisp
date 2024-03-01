(defpackage homestead/tests
  (:use :cl :fiveam)
  (:export :all-tests))

(in-package :homestead/tests)

(def-suite all-tests :description "Top-level test suite for all tests.")

(defun run-all! ()
  (let ((ok (run! 'all-tests)))
    (if ok
      (format t "✅ All tests passed")
      (error "❌ At least one suite failed"))))
