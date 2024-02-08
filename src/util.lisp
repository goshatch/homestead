(defpackage homestead/util
  (:use #:cl)
  (:export #:join))
(in-package :homestead/util)

(defun join (list &optional (separator ", "))
  (format nil (concatenate 'string "~{~A~^" separator "~}") list))
