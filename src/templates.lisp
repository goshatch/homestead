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
  (let ((html (cl-ppcre:split "{{\\s(.*)\\s}}" (util:slurp template) :with-registers-p t)))
    (util:join
      (mapcar (lambda (str)
                (if (ppcre:scan "^\\(" str)
                  (eval (read-from-string str))
                  str))
        html)
      "")))

(defun include (filename)
  "Include a partial template at the location of the call"
  (util:slurp (concatenate 'string "resources/site/_includes/" filename)))
