(defpackage homestead/templates
  (:use #:cl)
  (:export #:render #:include))
(in-package :homestead/templates)

;;; Templates are rendered in a html file as such:
;;;
;;; <div>
;;;   {{ (include "footer") }}
;;; </div>
;;;
;;; This will look in the _includes directory for a file named footer.html or
;;; footer.md (or any allowed extension.)

(defun render (template)
  "Render a full or partial template"
  template)

(defun include (filename)
  "Include a partial template at the location of the call"
  filename)
