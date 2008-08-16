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
    ('() '())
    ((e)      `(cons ,e '()))
    ((e . es) `(cons ,e (test . ,es)))))

(define-syntax is
  (macro
    ((e) (hd e))
    ((e . es) `(if (== ,e (is ,es)) 'true
		   (begin 
		     (: io format '"Test ~p failed. ~p =/= ~p~n" (list ',e ,e (is ,es)))
		     'false)))))

(define (inc-true x li)
  (+ x (if (== (hd li) 'true) 1 0)))
(define (inc-false x li)
  (+ x (if (== (hd li) 'false) 
	 (begin
	   1)
	 0)))

(define (cs x) (cs-new x 0 0 x ))
(define (cs-new li success fail testname)
  (if (is_atom li)
    li
    (if (== li '())    
      (list (hd testname) success fail)
      (if (is_list (hd li))
	(cons (cs (hd li))
	      (cs-new (tl li) (inc-true success li) (inc-false fail li) testname))
	(begin (cs (hd li)) 
	       (cs-new (tl li) (inc-true success li) (inc-false fail li) testname))))))

