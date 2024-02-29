(defpackage homestead/config
  (:nicknames #:conf)
  (:use #:cl)
  (:export
    #:init
    #:get-setting))

(in-package :homestead/config)

(defun init ()
  "Initialises the global configuration plist"
  (defvar *config*
    '(:allowed-extensions ("html" "md")
       :contents-dir "resources/contents"
       :build-dir "resources/build")))

(defun get-setting (key)
  "Get a configuration value by its KEY"
  (getf *config* key))
