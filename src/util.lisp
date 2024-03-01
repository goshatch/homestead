(defpackage homestead/util
  (:nicknames #:util)
  (:use #:cl)
  (:export
    #:join
    #:slurp
    #:merge-plists
    #:ansi-red
    #:ansi-green
    #:ansi-strong
    #:build-path
    #:build-output-path
    #:find-file-path
    #:find-include-path
    #:find-layout-path))

(in-package :homestead/util)

(defun join (list &optional (separator ", "))
  "Joins a LIST of strings into a single string, using SEPARATOR between items."
  (format nil (concatenate 'string "~{~A~^" separator "~}") list))

(defun slurp (pathname)
  "Reads the entire contents of the file at PATHNAME and returns it as a string.
   An error of the type file-error is signaled if the file at PATHNAME does not
   exist."
  (if (probe-file pathname)
    (with-open-file (stream pathname
                      :direction :input
                      :if-does-not-exist :error)
      (with-output-to-string (out)
        (loop for line = (read-line stream nil nil)
          while line do (write-string line out)
          (write-char #\Newline out))))
    nil))

(defun merge-plists (p1 p2)
  "Merge two plists, P1 and P2. Values from P2 override values from P1."
  (let ((result (copy-list p1)))
    (loop for (key value) on p2 by #'cddr
      do (setf (getf result key) value))
    result))

(defun ansi-red (string)
  "Wrap STRING in ANSI escape codes for red text"
  (format nil "~c[31m~a~c[0m" #\Esc string #\Esc))

(defun ansi-green (string)
  "Wrap STRING in ANSI escape codes for green text"
  (format nil "~c[32m~a~c[0m" #\Esc string #\Esc))

(defun ansi-strong (string)
  "Wrap STRING in ANSI escape codes for strong text."
  (format nil "~c[1;37m~a~c[0m" #\Esc string #\Esc))

(defun build-path (permalink &optional (extension "html"))
  "Return path for file with extension EXTENSION representing PERMALINK"
  (let ((permalink (if (string= permalink "/") "index" permalink)))
    (concatenate 'string (conf:get-setting :contents-dir) "/" permalink "." extension)))

(defun build-output-path (permalink)
  "Return output file path for node PERMALINK"
  (let ((permalink (if (string= permalink "/") "" permalink)))
    (concatenate 'string (conf:get-setting :build-dir) "/" permalink "/index.html")))

(defun find-file-path (permalink)
  "Find the file with the appropriate extension for PERMALINK"
  (let ((possible-paths
          (mapcar
            (lambda (ext) (build-path permalink ext))
            (conf:get-setting :allowed-extensions))))
    (find-if (lambda (path) (probe-file path)) possible-paths)))

(defun find-include-path (name)
  "Find the file with the appropriate extension for the include with NAME"
  (find-file-path
    (concatenate 'string "_includes/" name)))

(defun find-layout-path (name)
  "Find the file for the layout with NAME"
  (find-file-path
    (concatenate 'string "_layouts/" name)))
