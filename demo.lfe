(define-module demo
  (export (tsuite 0)))

(include-file "rt.lfe")

(define (tsuite)
  (test 'test-add
	(is (+ 1 1) 3)))

