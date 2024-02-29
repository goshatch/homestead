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

(defun build-full-permalink (permalink &optional parent-permalink)
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
           (full-permalink (build-full-permalink permalink parent-permalink)))
      ;; NOTE: The below is not great, ideally we probably shouldn't be
      ;; manipulating the node from here. Have to find a better option.
      (node:a-set node :permalink full-permalink)
      (node:process node)
      (dolist (child children)
        (process-metadata-tree child full-permalink)))
    (let ((siblings (cdr tree)))
      (when siblings
        (process-metadata-tree siblings parent-permalink)))))
