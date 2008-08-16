(define-module demo
  (export (start 0)))

(include-file "rt.lfe")

(define (start)
  (cs 
   (test 'setup
	 (is 1 2)
	 (test 'test1
	       (is 1 2)
	       (test 'test11
		     (is 1 2))
	       (test 'test12
		     (is 1 2))
	       (test 'test13
		     (is 1 2)))
	 (test 'test2
	       (is 1 2)
	       (test 'test22
		     (is 1 2))))))
   
   
  