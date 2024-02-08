(defpackage homestead
  (:use #:cl)
  (:local-nicknames (#:util #:homestead/util)))
(in-package :homestead)

(defun load-metadata (&optional (file-path "resources/metadata.lisp"))
  (with-open-file (in file-path)
    (with-standard-io-syntax
      (read in))))

(defun process-metadata-node (node full-permalink)
  (let* ((attributes (cadr node))
          (title (getf attributes :title))
          (rss (getf attributes :rss))
          (keywords (getf attributes :keywords)))
    (format t
      "page: \"~a\" [~a] rss? ~a | kwd: ~a~%"
      title
      full-permalink
      (if rss "YES" "no")
      (if keywords (util:join keywords) "none"))))

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
      (process-metadata-node node full-permalink)
      (dolist (child children)
        (process-metadata-tree child full-permalink)))
    (let ((siblings (cdr tree)))
      (when siblings
        (process-metadata-tree siblings parent-permalink)))))
