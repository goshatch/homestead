(defsystem "homestead"
  :version "0.0.1"
  :author "Gosha Tcherednitchenko <mail@gosha.net>"
  :license "MIT License"
  :depends-on (#:cl-markdown)
  :components ((:module "src"
                :components
                ((:file "main")
                 (:file "templates")
                 (:file "util"))))
  :description "A static website generator"
  :in-order-to ((test-op (test-op "homestead/tests"))))

(defsystem "homestead/tests"
  :author "Gosha Tcherednitchenko <mail@gosha.net>"
  :license "MIT License"
  :depends-on ("homestead"
               "fiveam")
  :components ((:module "tests"
                :components
                ((:file "main"))))
  :description "Test system for homestead"
  :perform (test-op (o s)
            (uiop:symbol-call :fiveam :run! 'homestead/tests/main:all-tests)))
