(defpackage homestead/node
  (:nicknames #:node)
  (:use #:cl)
  (:export
    #:attrs
    #:a-get
    #:a-set
    #:process))

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

(defun process (node)
  "Process a NODE and write output file"
  (handler-case
    (let ((output-html (homestead/templates:render-node node)))
      (with-open-file (stream (util:build-output-path (a-get node :permalink))
                        :direction :output
                        :if-exists :supersede
                        :if-does-not-exist :create)
        (write-sequence output-html stream))
      (format t "[OK] ~a~%" (a-get node :permalink)))
    (error (err)
      (format t "[ERROR] processing failed: ~a (~a)~%" (a-get node :permalink) err))))
