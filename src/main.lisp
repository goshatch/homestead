(defpackage homestead
  (:use :cl))
(in-package :homestead)

(defun separate-content-and-frontmatter (file-path)
  (with-open-file (stream file-path)
    (let* ((line (read-line stream nil nil))
            (in-frontmatter (string= line "---"))
            frontmatter
            content)
      (setf frontmatter (with-output-to-string (s)
                          (when in-frontmatter
                            (loop while in-frontmatter do
                              (setf line (read-line stream nil nil))
                              (if (string= line "---")
                                (setf in-frontmatter nil)
                                (write-line line s))))))
      (setf content (with-output-to-string (s)
                      (loop with end-of-file = nil
                        while (setf line (read-line stream nil end-of-file))
                        do (write-line line s))))
      (list frontmatter content))))
