(defpackage homestead/tests/util
  (:use :cl :fiveam)
  (:export :util-test-suite :|util-test-suite|))

(in-package :homestead/tests/util)

(def-suite
  util-test-suite
  :description "Util test suite"
  :in homestead/tests:all-tests)
(in-suite util-test-suite)

(test join
  (let ((list '("a" "b")))
    (is (string= (homestead/util:join list) "a, b"))
    (is (string= (homestead/util:join list " | ") "a | b"))))

(test slurp
  (let ((missing-file "/tmp/homestead-test-utils-slurp-missing-file.txt"))
    (is (equal '() (homestead/util:slurp missing-file))))
  (let ((test-file "/tmp/homestead-test-utils-slurp-test-file.txt"))
    (with-open-file (out test-file
                      :direction :output
                      :if-exists :supersede
                      :if-does-not-exist :create)
      (format out "Hello, World!!!"))
    (let ((content (homestead/util:slurp test-file)))
      (is (string= content (format nil "Hello, World!!!~%"))))))

(test merge-plists
  (let* ((plist1 '(:a "a" :b "b"))
         (plist2 '(:c "c" :d "d"))
         (merged (homestead/util:merge-plists plist1 plist2)))
    (is (string= (getf merged :a) "a"))
    (is (string= (getf merged :b) "b"))
    (is (string= (getf merged :c) "c"))
    (is (string= (getf merged :d) "d")))
  (let* ((plist1 '(:a "a" :b "b"))
         (plist2 '(:b "bee" :c "c"))
         (merged (homestead/util:merge-plists plist1 plist2)))
    (is (string= (getf merged :a) "a"))
    (is (string= (getf merged :b) "bee"))
    (is (string= (getf merged :c) "c"))))
