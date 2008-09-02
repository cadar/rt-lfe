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
      (let ((new-success (inc-true success li))
	    (new-fail (inc-false fail li)))
	(if (is_list (hd li))
	  (cons (count-success (hd li))
		(count-success-new (tl li) new-success new-fail testname))
	  (begin 
	    (count-success (hd li))
	    (count-success-new (tl li) new-success new-fail testname)))))))

(define-syntax off (macro (e ''nop)))
(define-syntax on  (macro ((e) e)))


(define (pr-line atom-name level)
  (let* ((space (: lists duplicate level '" "))
	 (name (atom_to_list (hd atom-name)))
	 (space_name (: lists concat (list (list space) (list name))))
	 ((success . (fail . '())) (tl atom-name)))
    (: io fwrite '"~-20.20sSuccess ~3w  Fail ~3w~n" 
       (list space_name success fail))))

(define (print-foreach x level)
  (: lists map (lambda (x) (indent x level)) x))

(define (indent li level)
  (if (< (length li) 4)
    (pr-line li level)
    (let* (((tuple rest last) (: lists split (- (length li) 3) li)))
 (pr-line last level)
      (print-foreach rest (+ level 2)))))

(define (sum-test li f)
  (if (== (length li) 3)
    (apply f (list li))
    (begin 
      (+ (if (== (is_list (hd li)) 'true)
	   (sum-test (hd li) f)
	   0)
	 (sum-test (tl li) f)))))

(define (show-result type tests)
  (let* ((sum (count-success tests))
	 (success (sum-test sum (lambda (x) (hd (tl x)))))
	 (fail (sum-test sum (lambda (x) (hd (tl (tl x)))))))
    (: io format '"~n")
    (if (== type 'full)
      (begin 
	(: io format '"-----------------------------------------~n")
	(print-foreach (list sum) 0)
	(: io format '"-----------------------------------------~n")
	(: io format '"Total~15cSuccess ~3w  Fail ~3w~n" (list 32 success fail)))
      (: io format '"Total Success ~p Fail ~p~n" (list success fail)))))

