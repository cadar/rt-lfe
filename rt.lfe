;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  rt.lfe - Regression Testing for LFE
;;
;;  2008-08-14 - cadar@github - Created
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define-syntax try-catch
  (macro 
    ((e) `(try ,e
	       (catch
		 ((tuple 'error n o) (tuple 'this-is-error n))
		 ((tuple 'throw n o) (tuple 'this-is-throw n))
		 ((tuple _ n o) (tuple 'this-is-default n)))))))

(define-syntax test
  (macro
    ('()      '())
    ((e)      `(cons ,e '()))
    ((e . es) `(cons ,e (test . ,es)))))

(define-syntax is
  (macro
    ((e) (hd e))
    ((e . es) `(let ((result ,e))
		 (if (== result (is ,es)) 
		 (begin
		   (: io format '".")
		   'true)
		 (begin 
		   (: io format '" ~p => ~p =/= ~p  Failing!~n"  (list ',e result (is ,es)))
		   'false))))))

(define (inc-true x li)
  (+ x (if (== (hd li) 'true) 1 0)))

(define (inc-false x li)
  (+ x (if (== (hd li) 'false) 1 0)))

(define (count-success x) (count-success-new x 0 0 x ))

(define (count-success-new li success fail testname)
  (if (or (is_atom li) 
	  (is_number li))
    li
    (if (== li '())    
      (list (hd testname) success fail)
      (if (is_list (hd li))
	(cons (count-success (hd li))
	      (count-success-new (tl li) 
				 (inc-true success li) 
				 (inc-false fail li) 
				 testname))
	(begin 
	  (count-success (hd li))
	  (count-success-new (tl li) 
			     (inc-true success li) 
			     (inc-false fail li) testname))))))

(define (show-result x)
  (: io format '"~n~p~n" 
     (list (count-success x))))
			  