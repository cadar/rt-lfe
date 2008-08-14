;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  rt.lfe - Regression Testing LFE
;;
;;  2008-08-14 - Mats Westin - Created
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;   Compile with:
;;     erl -noshell -pa $WORK_PATH -pa $LFE_PATH \
;;         -eval 'code:load_file(lfe_test).' \
;;         -eval 'io:format("~n~p~n",[lfe_test:start()]).' -s erlang halt
;;   Run test with: 
;;     erl -noshell -pa $WORK_PATH -pa $LFE_PATH \
;;         -eval 'code:load_file(lfe_test).' \
;;         -eval 'io:format("~n~p~n",[lfe_test:start()]).' -s erlang halt
;;
;;   Change lfe_test to the name of your module. /Mats
;;

(define-syntax try-catch
  (macro 
    ((e) `(try ,e
	       (catch
		 ((tuple 'error n o) (tuple 'this-is-error n))
		 ((tuple 'throw n o) (tuple 'this-is-throw n))
		 ((tuple _ n o) (tuple 'this-is-default n)))))))

(define-syntax test
  (macro
    ((e)      `(cons (try-catch ,e) '()))
    ((e . es) `(cons (try-catch ,e) (test . ,es)))))

;; Sounds important ;)
(define (success? x)
  (if (== x 'true) 1 0))

(define (fail? x tests)
  (if (== x 'false) 
    (begin 
      (: io format '"~p~n" tests) 
      1) 
    0))

(define (count-success-old tests) 
  `((success ,(: lists sum 
		(: lists map 
		  (lambda (x) (success? x)) 
		  tests)))
    (fail ,(: lists sum 
	     (: lists map 
	       (lambda (x) (fail? x tests))
	       tests)))))

(define (count-success tests) 
  (pln tests))

(define (test-test)
  (test 'testing-tests 
	(== (success? 'true) 1)
	(== (success? 'false) 0)
	(== (fail? 'false '(true false)) 1)
	(== (fail? 'true '(true false)) 0)))