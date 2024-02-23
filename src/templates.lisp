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

(defun render-in-layout (path &optional (layout "base"))
  "Render the template at PATH within LAYOUT"
  (let ((html (cl-ppcre:split "{{\\s(\\(content\\))\\s}}" (util:slurp (util:find-layout-path layout)) :with-registers-p t)))
    (util:join
      (mapcar (lambda (str)
                (if (ppcre:scan "^\\(content\\)$" str)
                  (render path)
                  str))
        html)
      "")))

(defun render (path)
  "Render a full or partial template at PATH"
  (let ((html (cl-ppcre:split "{{\\s(.*)\\s}}" (util:slurp path) :with-registers-p t)))
    (util:join
      (mapcar (lambda (str)
                (if (ppcre:scan "^\\(" str)
                  (eval (read-from-string str))
                  str))
        html)
      "")))

(defun include (filename)
  "Include a partial template represented by FILENAME at the location of the call"
  (render (util:find-include-path filename)))
