(define-module demo
  (export (start 0)))

(include-file "rt.lfe")

(define (start)
  (count-success
   (test-test)))
