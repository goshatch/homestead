(defsystem "homestead"
  :version "0.0.1"
  :author "Gosha Tcherednitchenko <mail@gosha.net>"
  :license "MIT License"
  :depends-on (#:cl-markdown #:cl-ppcre)
  :components ((:module "src"
                :components
                ((:file "config")
                 (:file "util" :depends-on ("config"))
                 (:file "templates" :depends-on ("util"))
                 (:file "node" :depends-on ("templates"))
                 (:file "main" :depends-on ("util" "node")))))
  :description "A static website generator"
  :in-order-to ((test-op (test-op "homestead-tests"))))

(defsystem "homestead-tests"
  :depends-on (#:homestead #:fiveam)
  :serial t
  :components ((:module "tests"
                :components ((:file "all")
                             (:file "test-util" :depends-on ("all")))))
  :perform (test-op (o c)
             (symbol-call :homestead/tests :run-all!)))
