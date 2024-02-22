(defpackage homestead/util
  (:nicknames #:util)
  (:use #:cl)
  (:export #:join #:slurp))

(in-package :homestead/util)

(defun join (list &optional (separator ", "))
  "Joins a LIST of strings into a single string, using SEPARATOR between items."
  (format nil (concatenate 'string "~{~A~^" separator "~}") list))

(defun slurp (pathname)
  "Reads the entire contents of the file at PATHNAME and returns it as a string."
  (with-output-to-string (out)
    (with-open-file (stream pathname
                      :direction :input
                      :if-does-not-exist :error)
      (loop for line = (read-line stream nil nil)
        while line do (write-string line out)
        (write-char #\Newline out)))))
