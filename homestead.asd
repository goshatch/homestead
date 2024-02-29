(defsystem "homestead"
  :version "0.0.1"
  :author "Gosha Tcherednitchenko <mail@gosha.net>"
  :license "MIT License"
  :depends-on (#:cl-markdown #:cl-ppcre)
  :components ((:module "src"
                :components
                ((:file "config")
                 (:file "util" :depends-on ("config"))
                 (:file "node")
                 (:file "templates" :depends-on ("util"))
                 (:file "main" :depends-on ("util" "templates" "node")))))
  :description "A static website generator")
