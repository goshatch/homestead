(defpackage homestead/templates
  (:use #:cl))
(in-package :homestead/templates)

;;; Templates are rendered in a html file as such:
;;;
;;; <div>
;;;   <%= (include "footer") %>
;;; </div>
;;;
;;; This will look in the _includes directory for a file named footer.html or
;;; footer.md (or any allowed extension.)

(defun render ()
  "Render a full or partial template")

(defun include ()
  "Include a partial template at the location of the call")
