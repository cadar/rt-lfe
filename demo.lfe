(define-module demo
  (export (start 0)))

(include-file "rt.lfe")

(define (start)
  (show-result 'full
	       (test 'test-add
		     (is (+ 1 1) 2)
		     (is (+ 1 -2) -1)
		     (is (+ 0 0) 0)
		     (is (+ 10 10) 11))))
  