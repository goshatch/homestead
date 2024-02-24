(defpackage homestead
  (:use #:cl)
  (:export #:get-setting))
(in-package :homestead)

(defvar *settings*
  '(:allowed-extensions ("html" "md")
     :contents-dir "resources/contents"
     :build-dir "resources/build"))

(defun get-setting (key)
  "Get a setting value by its KEY"
  (getf *settings* key))

(defun load-metadata (&optional (file-path "resources/metadata.lisp"))
  (with-open-file (in file-path)
    (with-standard-io-syntax
      (read in))))

;;; TODO: See building a self-contained executable with SBCL
;;; https://lispcookbook.github.io/cl-cookbook/scripting.html#with-sbcl---images-and-executables
(defun main ()
  "Entry point for Homestead")

(defun process-metadata-node (node)
  "Process a NODE and write output file"
  (let ((attrs (cadr node)))
    (with-open-file (stream (util:build-output-path (getf attrs :permalink))
                      :direction :output
                      :if-exists :supersede
                      :if-does-not-exist :create)
      (write-sequence (homestead/templates:render-node node) stream))))

;; (defun process-metadata-node (node children)
;;   (let* ((attributes (cadr node))
;;           (title (getf attributes :title))
;;           (rss (getf attributes :rss))
;;           (keywords (getf attributes :keywords))
;;           (permalink (getf attributes :permalink))
;;           (children-count (length (car children))))
;;     (format t
;;       "page: \"~a\" [~a] rss? ~a | kwd: ~a | chld: ~a~%"
;;       title
;;       permalink
;;       (if rss "YES" "no")
;;       (if keywords (util:join keywords) "none")
;;       children-count)))

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
      (setf (getf node :permalink) full-permalink)
      (process-metadata-node node)
      (dolist (child children)
        (process-metadata-tree child full-permalink)))
    (let ((siblings (cdr tree)))
      (when siblings
        (process-metadata-tree siblings parent-permalink)))))
