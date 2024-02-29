(defpackage homestead/node
  (:nicknames #:node)
  (:use #:cl)
  (:export
    #:attrs
    #:a-get
    #:a-set))

(in-package :homestead/node)

(defun attrs (node)
  "Retrieve the attributes plist for NODE"
  (cadr node))

(defun a-get (node attr)
  "Retrieve the ATTR attribute from the attributes plist for NODE"
  (getf (node:attrs node) attr))

(defun a-set (node attr value)
  "Set the value of the ATTR attribute for NODE to VALUE"
  (setf (getf (cadr node) attr) value))
