(defpackage homestead/templates
  (:use #:cl)
  (:export #:render-node #:render #:include))
(in-package :homestead/templates)

;;; NOTE: Templates are rendered in a html file as such:
;;;
;;; <div>
;;;   {{ (include "footer") }}
;;; </div>
;;;
;;; This will look in the _includes directory for a file named footer.html or
;;; footer.md (or any allowed extension.)

(defvar *default-node-attrs* '(:layout "base"))
(defvar *node-attrs*)

(defun render-node (node)
  "Set node attributes and start rendering process"
  (let ((attrs (cadr node)))
    (setf *node-attrs* (util:merge-plists *default-node-attrs* attrs))
    (render-in-layout)))

(defun render-in-layout ()
  (render (util:find-layout-path (getf *node-attrs* :layout))))

(defun content ()
  (render (util:find-file-path (getf *node-attrs* :permalink))))

(defun include (filename)
  "Include a partial template represented by FILENAME at the location of the call"
  (render (util:find-include-path filename)))

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
