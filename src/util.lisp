(defpackage homestead/util
  (:nicknames #:util)
  (:use #:cl)
  (:export
    #:join
    #:slurp
    #:build-path
    #:find-file-path
    #:find-include-path))

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

(defun build-path (permalink &optional (extension "html"))
  "Return path for file with extension EXTENSION representing PERMALINK"
  (concatenate 'string (homestead:get-setting "site-root") "/" permalink "." extension))

(defun find-file-path (permalink)
  "Find the file with the appropriate extension for PERMALINK"
  (let ((possible-paths
          (mapcar
            (lambda (ext) (build-path permalink ext))
            (homestead:get-setting "allowed-extensions"))))
    (find-if (lambda (path) (probe-file path)) possible-paths)))

(defun find-include-path (name)
  "Find the file with the appropriate extension for the include with NAME"
  (find-file-path
    (concatenate 'string "_includes/" name)))
