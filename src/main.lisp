(defpackage homestead
  (:use #:cl)
  (:export #:get-setting))
(in-package :homestead)

(defun load-metadata (&optional (file-path "resources/metadata.lisp"))
  (with-open-file (in file-path)
    (with-standard-io-syntax
      (read in))))

;;; TODO: See building a self-contained executable with SBCL
;;; https://lispcookbook.github.io/cl-cookbook/scripting.html#with-sbcl---images-and-executables
(defun main ()
  "Entry point for Homestead"
  (conf:init)
  (process-metadata-tree (load-metadata)))

(defun process-metadata-node (node)
  "Process a NODE and write output file"
    (handler-case
      (let ((output-html (homestead/templates:render-node node)))
        (with-open-file (stream (util:build-output-path (node:a-get node :permalink))
                          :direction :output
                          :if-exists :supersede
                          :if-does-not-exist :create)
          (write-sequence output-html stream))
        (format t "[OK] ~a" (node:a-get node :permalink)))
      (error (err)
        (format t "[ERROR] processing failed: ~a (~a)~%" (node:a-get node :permalink) err))))

(defun full-permalink (permalink &optional parent-permalink)
  (if parent-permalink
    (concatenate 'string
      parent-permalink
      (if (string= parent-permalink "/")
        permalink
        (concatenate 'string "/" permalink)))
    permalink))

(defun process-metadata-tree (tree &optional parent-permalink)
  (when tree
    (let* ((node (car tree))
           (permalink (car node))
           (children (list (cddr node)))
           (full-permalink (full-permalink permalink parent-permalink)))
      (node:a-set node :permalink full-permalink)
      (process-metadata-node node)
      (dolist (child children)
        (process-metadata-tree child full-permalink)))
    (let ((siblings (cdr tree)))
      (when siblings
        (process-metadata-tree siblings parent-permalink)))))
