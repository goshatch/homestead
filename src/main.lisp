(defpackage homestead
  (:use #:cl)
  (:export #:get-setting))
(in-package :homestead)

(defparameter *settings* (make-hash-table :test 'equal))

(defun init-settings ()
  "Initialise global settings hash table"
  (let ((pairs '(("allowed-extensions" . (list "html" "md"))
                 ("site-root" . "resources/site"))))
    (dolist (pair pairs)
      (setf (gethash (car pair) *settings*) (cdr pair)))))

(defun get-setting (key)
  "Get a setting value by its KEY"
  (gethash key *settings*))

(defun load-metadata (&optional (file-path "resources/metadata.lisp"))
  (with-open-file (in file-path)
    (with-standard-io-syntax
      (read in))))

;;; TODO: See building a self-contained executable with SBCL
;;; https://lispcookbook.github.io/cl-cookbook/scripting.html#with-sbcl---images-and-executables
(defun main ()
  "Entry point for Homestead"
  (init-settings))

(defun process-metadata-node (node children full-permalink)
  (let* ((attributes (cadr node))
          (title (getf attributes :title))
          (rss (getf attributes :rss))
          (keywords (getf attributes :keywords))
          (children-count (length (car children))))
    (format t
      "page: \"~a\" [~a] rss? ~a | kwd: ~a | chld: ~a~%"
      title
      full-permalink
      (if rss "YES" "no")
      (if keywords (util:join keywords) "none")
      children-count)))

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
      (process-metadata-node node children full-permalink)
      (dolist (child children)
        (process-metadata-tree child full-permalink)))
    (let ((siblings (cdr tree)))
      (when siblings
        (process-metadata-tree siblings parent-permalink)))))
