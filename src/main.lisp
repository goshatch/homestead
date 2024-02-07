(defpackage homestead
  (:use :cl))
(in-package :homestead)

;; Example of metadata tree
;; '(("/"
;;     (:title "Home")
;;     ("projects"
;;       (:title "Projects"
;;         :rss t)
;;       ("astrovox"
;;         (:title "Astrovox"
;;           :date "2024-01-01"
;;           :keywords '("software" "synthesizer")))
;;       ("where-the-story-begins"
;;         (:title "Where the Story Begins"
;;           :date "2019-05-05"
;;           :keywords '("book design" "photography"))))
;;     ("blog"
;;       (:title "Blog"
;;         :rss t))
;;     ("about"
;;       (:title "About"))))

(defun process-metadata-tree (tree &optional parent-permalink)
  (when tree
    (let* ((node (car tree))
           (permalink (car node))
           (attributes (cadr node))
           (children (list (cddr node)))
           (full-permalink (if parent-permalink
                               (concatenate 'string
                                 parent-permalink
                                 (if (string= parent-permalink "/")
                                   permalink
                                   (concatenate 'string "/" permalink)))
                               permalink)))
      (format t "Processing page: \"~a\" [~a]~%" (getf attributes :title) full-permalink)
      (dolist (child children)
        (process-metadata-tree child full-permalink)))
    (let ((siblings (cdr tree)))
      (when siblings
        (process-metadata-tree siblings parent-permalink)))))
