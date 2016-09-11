(in-package :parseq)

(defrule terminal-t () t)
(defrule terminal-nil () nil)
(defrule terminal-symbol () 'a)
(defrule terminal-character () #\a)
(defrule terminal-string () "abc")
(defrule terminal-vector () #(1 2 3))
(defrule terminal-number () 5)
(defrule terminal-any-char () char)
(defrule terminal-any-byte () byte)
(defrule terminal-any-symbol () symbol)
(defrule terminal-any-form () form)
(defrule terminal-any-list () list)
(defrule terminal-any-vector () vector)
(defrule terminal-any-number () number)
(defrule terminal-any-string () string)

(defrule nonterminal-and () (and 'a 'b 'c))
(defrule nonterminal-and~ () (and~ 'a 'b 'c 'd))
(defrule nonterminal-or () (or 'a 'b 'c))
(defrule nonterminal-not () (not 'a))
(defrule nonterminal-* () (* 'a))
(defrule nonterminal-+ () (+ 'a))
(defrule nonterminal-? () (? 'a))
(defrule nonterminal-& () (& 'a))
(defrule nonterminal-! () (! 'a))
(defrule nonterminal-rep () (rep 4 'a))
(defrule nonterminal-rep-b () (rep (4) 'a))
(defrule nonterminal-rep-ab () (rep (3 5) 'a))
(defrule nonterminal-list () (list 'a))
(defrule nonterminal-string () (string #\a))
(defrule nonterminal-vector () (vector 4))

(defrule parameter-terminal (x) x)
(defrule parameter-terminal-indirect () (parameter-terminal 'a))
(defrule parameter-repeat (x) (rep x 'a))
(defrule parameter-constant (x) 'a (:constant x))

(defrule option-constant () (and 'a 'b 'c) (:constant 4))
(defrule option-lambda () (and 'a 'b 'c) (:lambda (x y z) (list z y x)))
(defrule option-lambda-rest () (and 'a 'b 'c) (:lambda (&rest items) (reverse items)))
(defrule option-destructure () (and (* 'a) 'b) (:destructure ((&rest a) b) `(,@a ,b)))
(defrule option-identity-t () (and 'a 'b 'c) (:identity t))
(defrule option-identity-n () (and 'a 'b 'c) (:identity nil))
(defrule option-flatten () (and (and 'a 'b) (and 'c 'd) (and 'e 'f)) (:flatten))
(defrule option-string () (and (and #\a "b") "cd" (and #\e #\f)) (:string))
(defrule option-string-symbol () (and (and #\a "b") "cd" (and #\e 'f)) (:string))
(defrule option-vector () (and (and 1 2) (and 3 4) (and 5 6)) (:vector))
(defrule option-test () number (:test (x) (= x 5)))
(defrule option-not () number (:not (x) (= x 5)))

(defrule multiopt-proc () number (:lambda (x) (1+ x)) (:lambda (x) (1+ x)))
(defrule multiopt-test-a () number (:test (x) (= x 5)) (:lambda (x) (1+ x)))
(defrule multiopt-test-b () number (:lambda (x) (1+ x)) (:test (x) (= x 5)))

(defrule bind-single () (and bind-single-number bind-single-repeat) (:let x))
(defrule bind-single-number () number (:external x) (:lambda (num) (setf x num)))
(defrule bind-single-repeat () (rep x 'a) (:external x))
(defrule bind-nest-number () number (:external x) (:lambda (num) (setf x num)))
(defrule bind-nest-repeat () (rep x bind-single) (:external x) )
(defrule bind-nest () (and bind-nest-number bind-nest-repeat) (:let x))

(defrule nest-or-and () (or (and 'a 'b) (and 'a 'c) (and 'd 'e)))
(defrule nest-and-or () (and (or 'a 'b) (or 'a 'c) (or 'd 'e)))
(defrule nest-*-and () (* (and 'a 'b)))
(defrule nest-and-* () (and (* 'a) (* 'b)))
(defrule nest-+-and () (+ (and 'a 'b)))
(defrule nest-and-+ () (and (+ 'a) (+ 'b)))
(defrule nest-list-list () (list (list 'a)))

(defrule recursion () (or (and 'a recursion) 'a))
(defrule left-recursion () (or (and 'a left-recursion 'b) (and left-recursion 'a) 'a))
(defrule left-recursion-indirect () (and (? 'b) left-recursion-indirect-2))
(defrule left-recursion-indirect-2 () (and (? 'b) left-recursion-indirect))

(defrule loop-name () (and 'named symbol))
(defrule loop-iteration-with () (and 'with symbol '= form (* (and 'and symbol '= form))))
(defrule loop-iteration-up () (and (? (and (or 'from 'upfrom) form)) (? (and (or 'upto 'to 'below) form))))
(defrule loop-iteration-down1 () (and 'from form (or 'downto 'above) form))
(defrule loop-iteration-down2 () (and 'downfrom form (? (and (or 'downto 'to 'above) form))))
(defrule loop-iteration-numeric () (and (or loop-iteration-down1 loop-iteration-down2 loop-iteration-up) (? (and 'by form))))
(defrule loop-iteration-list () (and (or 'in 'on) form (? (and 'by form))))
(defrule loop-iteration-flex () (and '= form (? (and 'then form))))
(defrule loop-iteration-vector () (and 'across form))
(defrule loop-iteration-key () (and (or 'hash-key 'hash-keys) (or 'of 'in) form (? (and 'using (list (and 'hash-value symbol))))))
(defrule loop-iteration-value () (and (or 'hash-value 'hash-values) (or 'of 'in) form (? (and 'using (list (and 'hash-key symbol))))))
(defrule loop-iteration-package () (and (or 'symbol 'symbols 'present-symbol 'present-symbols 'external-symbol 'external-symbols) (or 'of 'in) form))
(defrule loop-iteration-hash () (and 'being (or 'the 'each) (or loop-iteration-key loop-iteration-value loop-iteration-package)))
(defrule loop-iteration-for-body () (or loop-iteration-list loop-iteration-flex loop-iteration-vector loop-iteration-hash loop-iteration-numeric))
(defrule loop-iteration-for () (and (or 'for 'as) symbol loop-iteration-for-body (* (and 'and symbol loop-iteration-for-body))))
(defrule loop-iteration () (or loop-iteration-with loop-iteration-for))
(defrule loop-around () (and (or 'initially 'finally) (+ (not loop-post-iteration))))
(defrule loop-repeat () (and 'repeat form))
(defrule loop-test () (and (or 'while 'until 'always 'never 'thereis) form))
(defrule loop-control () (or loop-around loop-repeat loop-test))
(defrule loop-do () (and (or 'do 'doing) (+ (not loop-post-iteration))))
(defrule loop-condition-and () (and loop-action (* (and 'and loop-action))))
(defrule loop-condition () (and (or 'if 'when 'unless) form loop-condition-and (? (and 'else loop-condition-and)) (? 'end)))
(defrule loop-return () (and 'return (or 'it form)))
(defrule loop-collect () (and (or 'collect 'collecting 'append 'appending 'nconc 'nconcing) (or 'it form) (? (and 'into form))))
(defrule loop-stat () (and (or 'count 'counting 'sum 'summing 'maximize 'maximizing 'minimize 'minimizing) (or 'it form) (? (and 'into form))))
(defrule loop-action () (or loop-do loop-condition loop-return loop-collect loop-stat)) ;; +
(defrule loop-post-iteration () (or loop-control loop-action))
(defrule loop () (and (? loop-name) (* loop-iteration) (* loop-post-iteration)))

;; ----- Helpers ----------------------------------------

(defun xnor (&rest forms)
  (evenp (count-if #'identity forms)))

(defun test-parseq (expression list &optional success (result nil result-p) junk-allowed (test #'equal))
  (multiple-value-bind (rslt success-p) (parseq expression list :junk-allowed junk-allowed)
    (and (xnor success success-p) (or (not result-p) (funcall test rslt result)))))

;; ----- Tests - ----------------------------------------

(define-test terminal-test ()
  (check
    (test-parseq 'terminal-t '(t) t t)
    (test-parseq 'terminal-t '(5) t 5)
    (test-parseq 'terminal-t '(nil) nil nil)
    (test-parseq 'terminal-nil '(nil) t nil)
    (test-parseq 'terminal-nil '(()) t nil)
    (test-parseq 'terminal-nil '(t) nil nil)
    (test-parseq 'terminal-symbol '(a) t 'a)
    (test-parseq 'terminal-symbol '(b) nil nil)
    (test-parseq 'terminal-character '(#\a) t #\a)
    (test-parseq 'terminal-character '(#\b) nil nil)
    (test-parseq 'terminal-string "abc" t "abc")
    (test-parseq 'terminal-string '("abc") t "abc")
    (test-parseq 'terminal-string "def" nil nil)
    (test-parseq 'terminal-vector #(1 2 3) t #(1 2 3) nil #'equalp)
    (test-parseq 'terminal-vector '(#(1 2 3)) t #(1 2 3) nil #'equalp)
    (test-parseq 'terminal-vector #(4 5 6) nil nil #'equalp)
    (test-parseq 'terminal-number '(5) t 5)
    (test-parseq 'terminal-number '(4) nil nil)
    (test-parseq 'terminal-any-char '(#\f) t #\f)
    (test-parseq 'terminal-any-char '(#\g) t #\g)
    (test-parseq 'terminal-any-char '(f) nil nil)
    (test-parseq 'terminal-any-byte '(255) t 255)
    (test-parseq 'terminal-any-byte '(256) nil nil)
    (test-parseq 'terminal-any-byte '(0) t 0)
    (test-parseq 'terminal-any-byte '(-1) nil nil)
    (test-parseq 'terminal-any-symbol '(f) t 'f)
    (test-parseq 'terminal-any-symbol '(#\f) nil nil)
    (test-parseq 'terminal-any-form '(nil) t nil)
    (test-parseq 'terminal-any-form '(#\a) t #\a)
    (test-parseq 'terminal-any-form '((foo)) t '(foo))
    (test-parseq 'terminal-any-list '(nil) t nil)
    (test-parseq 'terminal-any-list '((+ 1 2)) t '(+ 1 2))
    (test-parseq 'terminal-any-list '(4) nil nil)
    (test-parseq 'terminal-any-vector '(#(1 2)) t #(1 2) nil #'equalp)
    (test-parseq 'terminal-any-vector '(4) nil nil nil #'equalp)
    (test-parseq 'terminal-any-number '(4) t 4)
    (test-parseq 'terminal-any-number '(#\4) nil nil)
    (test-parseq 'terminal-any-string '("foo") t "foo")
    (test-parseq 'terminal-any-string '(#\f) nil nil)))

(define-test and-test ()
  (check
    ;; (and 'a 'b 'c)
    (test-parseq 'nonterminal-and '(a b c) t '(a b c))
    (test-parseq 'nonterminal-and '(a b) nil nil)
    (test-parseq 'nonterminal-and '(a c) nil nil)
    (test-parseq 'nonterminal-and '(a) nil nil)))

(define-test and~-test ()
  (check
    ;; (and~ 'a 'b 'c 'd)
    (test-parseq 'nonterminal-and~ (shuffle '(a b c d)) t '(a b c d))
    (test-parseq 'nonterminal-and~ (shuffle '(a b c d)) t '(a b c d))
    (test-parseq 'nonterminal-and~ (shuffle '(a b c d)) t '(a b c d))
    (test-parseq 'nonterminal-and~ (shuffle '(a b c d)) t '(a b c d))
    (test-parseq 'nonterminal-and~ (shuffle '(a b c d)) t '(a b c d))
    (test-parseq 'nonterminal-and~ (shuffle '(a b c d)) t '(a b c d))
    (test-parseq 'nonterminal-and~ (shuffle '(a b c d)) t '(a b c d))
    (test-parseq 'nonterminal-and~ (shuffle '(a b c d)) t '(a b c d))
    (test-parseq 'nonterminal-and~ (shuffle '(a b c d)) t '(a b c d))
    (test-parseq 'nonterminal-and~ (shuffle '(a b c d)) t '(a b c d))
    (test-parseq 'nonterminal-and~ (shuffle '(a b c d)) t '(a b c d))
    (test-parseq 'nonterminal-and~ (shuffle '(a b c d)) t '(a b c d))
    (test-parseq 'nonterminal-and~ (shuffle '(a b c d)) t '(a b c d))
    (test-parseq 'nonterminal-and~ (shuffle '(a b c d)) t '(a b c d))
    (test-parseq 'nonterminal-and~ (shuffle '(a b c d)) t '(a b c d))
    (test-parseq 'nonterminal-and~ (shuffle '(a b c d)) t '(a b c d))
    (test-parseq 'nonterminal-and~ (shuffle '(a b c d)) t '(a b c d))
    (test-parseq 'nonterminal-and~ (shuffle '(a b c d)) t '(a b c d))
    (test-parseq 'nonterminal-and~ (shuffle '(a b c d)) t '(a b c d))
    (test-parseq 'nonterminal-and~ (shuffle '(a b c d)) t '(a b c d))
    (test-parseq 'nonterminal-and~ (shuffle '(a b c d)) t '(a b c d))
    (test-parseq 'nonterminal-and~ (shuffle '(a b c d)) t '(a b c d))
    (test-parseq 'nonterminal-and~ (shuffle '(a b c d)) t '(a b c d))
    (test-parseq 'nonterminal-and~ (shuffle '(a b c d)) t '(a b c d))

    (test-parseq 'nonterminal-and~ (shuffle '(a b c)) nil nil)
    (test-parseq 'nonterminal-and~ (shuffle '(a b c)) nil nil)
    (test-parseq 'nonterminal-and~ (shuffle '(a b c)) nil nil)
    (test-parseq 'nonterminal-and~ (shuffle '(a b c)) nil nil)
    (test-parseq 'nonterminal-and~ (shuffle '(a b c)) nil nil)
    (test-parseq 'nonterminal-and~ (shuffle '(a b c)) nil nil)

    (test-parseq 'nonterminal-and~ '(a b c d a) nil nil)
    (test-parseq 'nonterminal-and~ (shuffle '(a b c d a)) nil nil)
    (test-parseq 'nonterminal-and~ (shuffle '(a b c d a)) nil nil)
    (test-parseq 'nonterminal-and~ (shuffle '(a b c d a)) nil nil)
    (test-parseq 'nonterminal-and~ (shuffle '(a b c d a)) nil nil)
    (test-parseq 'nonterminal-and~ (shuffle '(a b c d a)) nil nil)
    (test-parseq 'nonterminal-and~ (shuffle '(a b c d a)) nil nil)
    (test-parseq 'nonterminal-and~ (shuffle '(a b c d a)) nil nil)
    (test-parseq 'nonterminal-and~ (shuffle '(a b c d a)) nil nil)
    (test-parseq 'nonterminal-and~ (shuffle '(a b c d a)) nil nil)))

(define-test or-test ()
  (check
    ;; (or 'a 'b 'c)
    (test-parseq 'nonterminal-or '(a) t 'a)
    (test-parseq 'nonterminal-or '(b) t 'b)
    (test-parseq 'nonterminal-or '(c) t 'c)
    (test-parseq 'nonterminal-or '(d) nil nil)))

(define-test not-test ()
  (check
    ;; (not 'a)
    (test-parseq 'nonterminal-not '() nil nil)
    (test-parseq 'nonterminal-not '(a) nil nil)
    (test-parseq 'nonterminal-not '(b) t 'b)))

(define-test *-test ()
  (check
    ;; (* 'a)
    (test-parseq 'nonterminal-* '() t nil)
    (test-parseq 'nonterminal-* '(a) t '(a))
    (test-parseq 'nonterminal-* '(a a) t '(a a))
    (test-parseq 'nonterminal-* '(a a a) t '(a a a))
    (test-parseq 'nonterminal-* '(b) nil nil)
    (test-parseq 'nonterminal-* '(b) t nil t)
    (test-parseq 'nonterminal-* '(a b) nil nil)
    (test-parseq 'nonterminal-* '(a b) t '(a) t)))

(define-test +-test ()
  (check
    ;; (+ 'a)
    (test-parseq 'nonterminal-+ '() nil nil)
    (test-parseq 'nonterminal-+ '(a) t '(a))
    (test-parseq 'nonterminal-+ '(a a) t '(a a))
    (test-parseq 'nonterminal-+ '(a a a) t '(a a a))
    (test-parseq 'nonterminal-+ '(b) nil nil)
    (test-parseq 'nonterminal-+ '(a b) nil nil)
    (test-parseq 'nonterminal-+ '(a b) t '(a) t)))

(define-test ?-test ()
  (check
    ;; (? 'a)
    (test-parseq 'nonterminal-? '() t nil)
    (test-parseq 'nonterminal-? '(a) t 'a)
    (test-parseq 'nonterminal-? '(b) t nil t)))

(define-test &-test ()
  (check
    ;; (& 'a)
    (test-parseq 'nonterminal-& '(a) t 'a t)
    (test-parseq 'nonterminal-& '(b) nil nil t)))

(define-test !-test ()
  (check
    ;; (! 'a)
    (test-parseq 'nonterminal-! '() nil nil)
    (test-parseq 'nonterminal-! '(a) nil nil)
    (test-parseq 'nonterminal-! '(b) t 'b t)))

(define-test rep-test ()
  (check
    ;; (rep 4 'a)
    (test-parseq 'nonterminal-rep '() nil nil)
    (test-parseq 'nonterminal-rep '(a a a) nil nil)
    (test-parseq 'nonterminal-rep '(a a a a) t '(a a a a))
    (test-parseq 'nonterminal-rep '(a a a a a) nil nil)
    ;; (rep (4) 'a)
    (test-parseq 'nonterminal-rep-b '() t '())
    (test-parseq 'nonterminal-rep-b '(a) t '(a))
    (test-parseq 'nonterminal-rep-b '(a a) t '(a a))
    (test-parseq 'nonterminal-rep-b '(a a a) t '(a a a))
    (test-parseq 'nonterminal-rep-b '(a a a a) t '(a a a a))
    (test-parseq 'nonterminal-rep-b '(a a a a a) nil nil)
    ;; (rep (3 5) 'a)
    (test-parseq 'nonterminal-rep-ab '(a a) nil nil)
    (test-parseq 'nonterminal-rep-ab '(a a a) t '(a a a))
    (test-parseq 'nonterminal-rep-ab '(a a a a) t '(a a a a))
    (test-parseq 'nonterminal-rep-ab '(a a a a a) t '(a a a a a))
    (test-parseq 'nonterminal-rep-ab '(a a a a a a) nil nil)))

(define-test list-test ()
  (check
    ;; (list 'a)
    (test-parseq 'nonterminal-list '() nil nil)
    (test-parseq 'nonterminal-list '(a) nil nil)
    (test-parseq 'nonterminal-list '((a)) t '(a))
    (test-parseq 'nonterminal-list '((b)) nil nil)
    (test-parseq 'nonterminal-list '(#(a)) nil nil)))

(define-test string-test ()
  (check
    ;; (string #\a)
    (test-parseq 'nonterminal-string '("") nil nil)
    (test-parseq 'nonterminal-string '("a") t '(#\a))
    (test-parseq 'nonterminal-string '("b") nil nil)
    (test-parseq 'nonterminal-string '("ab") nil nil)
    (test-parseq 'nonterminal-string '((#\a)) nil nil)))

(define-test vector-test ()
  (check
    ;; (vector 4)
    (test-parseq 'nonterminal-vector '(#()) nil nil)
    (test-parseq 'nonterminal-vector '(#(3)) nil nil)
    (test-parseq 'nonterminal-vector '(#(4)) t '(4))
    (test-parseq 'nonterminal-vector '(#(4 5)) nil nil)
    (test-parseq 'nonterminal-vector '((4)) nil nil)))

(define-test parameter-test ()
  (check
    ;; x
    (test-parseq '(parameter-terminal 'a) '(a) t 'a)
    (test-parseq '(parameter-terminal 'a) '(b) nil nil)
    (test-parseq '(parameter-terminal #\a) "a" t #\a)
    (test-parseq '(parameter-terminal #\a) "b" nil nil)
    (test-parseq '(parameter-terminal "abc") "abc" t "abc")
    (test-parseq '(parameter-terminal "abc") "def" nil nil)
    (test-parseq '(parameter-terminal "abc") '("abc") t "abc")
    (test-parseq '(parameter-terminal "abc") '("def") nil nil)
    (test-parseq '(parameter-terminal #(1 2 3)) #(1 2 3) t #(1 2 3) nil #'equalp)
    (test-parseq '(parameter-terminal #(1 2 3)) #(4 5 6) nil nil)
    (test-parseq '(parameter-terminal #(1 2 3)) '(#(1 2 3)) t #(1 2 3) nil #'equalp)
    (test-parseq '(parameter-terminal #(1 2 3)) '(#(4 5 6)) nil nil)
    (test-parseq '(parameter-terminal 5) '(5) t 5)
    (test-parseq '(parameter-terminal 5) '(6) nil nil)
    ;; (parameter-terminal 'a)
    (test-parseq 'parameter-terminal-indirect '(a) t 'a)
    ;; (rep x 'a))
    (test-parseq '(parameter-repeat 3) '(a a) nil nil)
    (test-parseq '(parameter-repeat 3) '(a a a) t '(a a a))
    (test-parseq '(parameter-repeat 3) '(a a a a) nil nil)
    ;; 'a (:constant x)
    (test-parseq '(parameter-constant b) '(a) t 'b)))

(define-test option-test ()
  (check
    ;; (and 'a 'b 'c) (:constant 4)
    (test-parseq 'option-constant '(a b c) t 4)
    ;; (and 'a 'b 'c) (:lambda (x y z) (list z y x))
    (test-parseq 'option-lambda '(a b c) t '(c b a))
    ;; (and 'a 'b 'c) (:lambda (&rest items) (reverse items))
    (test-parseq 'option-lambda-rest '(a b c) t '(c b a))
    ;; (and (* 'a) 'b) (:destructure ((&rest a) b) `(,@a ,b))
    (test-parseq 'option-destructure '(a a a b) t '(a a a b))
    ;; (and 'a 'b 'c) (:identity t)
    (test-parseq 'option-identity-t '(a b c) t '(a b c))
    ;; (and 'a 'b 'c) (:identity nil)
    (test-parseq 'option-identity-n '(a b c) t nil)
    ;; (and (and 'a 'b) (and 'c 'd) (and 'e 'f)) (:flatten)
    (test-parseq 'option-flatten '(a b c d e f) t '(a b c d e f))
    ;; (and (and #\a "b") "cd" (and #\e #\f)) (:string)
    (test-parseq 'option-string "abcdef" t "abcdef")
    (test-parseq 'option-string '(#\a "b" "cd" #\e #\f) t "abcdef")
    (test-parseq 'option-string #(#\a "b" "cd" #\e #\f) t "abcdef")
    ;; (and (and #\a "b") "cd" (and #\e 'f)) (:string)
    (test-parseq 'option-string-symbol '(#\a "b" "cd" #\e f) t "abcdeF")
    (test-parseq 'option-string-symbol #(#\a "b" "cd" #\e f) t "abcdeF")
    ;; (and (and 1 2) (and 3 4) (and 5 6)) (:vector)
    (test-parseq 'option-vector '(1 2 3 4 5 6) t #(1 2 3 4 5 6) nil #'equalp)
    (test-parseq 'option-vector #(1 2 3 4 5 6) t #(1 2 3 4 5 6) nil #'equalp)
    ;; number (:test (x) (= x 5))
    (test-parseq 'option-test '(4) nil nil)
    (test-parseq 'option-test '(5) t 5)
    (test-parseq 'option-test '(6) nil nil)
    ;; number (:not (x) (= x 5))
    (test-parseq 'option-not '(4) t 4)
    (test-parseq 'option-not '(5) nil nil)
    (test-parseq 'option-not '(6) t 6)))

(define-test multiopt-test ()
  (check
    ;; number (:lambda (x) (1+ x)) (:lambda (x) (1+ x)))
    (test-parseq 'multiopt-proc '(5) t 7)
    ;; number (:test (x) (= x 5)) (:lambda (x) (1+ x)))
    (test-parseq 'multiopt-test-a '(4) nil nil)
    (test-parseq 'multiopt-test-a '(5) t 6)
    ;; number (:lambda (x) (1+ x)) (:test (x) (= x 5)))
    (test-parseq 'multiopt-test-b '(4) t 5)
    (test-parseq 'multiopt-test-b '(5) nil nil)))

(define-test nesting-test ()
  (check
    ;; (or (and 'a 'b) (and 'a 'c) (and 'd 'e))
    (test-parseq 'nest-or-and '(a) nil nil)
    (test-parseq 'nest-or-and '(a b) t '(a b))
    (test-parseq 'nest-or-and '(a c) t '(a c))
    (test-parseq 'nest-or-and '(a e) nil nil)
    (test-parseq 'nest-or-and '(d) nil nil)
    (test-parseq 'nest-or-and '(d e) t '(d e))

    ;; (and (or 'a 'b) (or 'a 'c) (or 'd 'e))
    (test-parseq 'nest-and-or '(a) nil nil)
    (test-parseq 'nest-and-or '(b) nil nil)
    (test-parseq 'nest-and-or '(a a) nil nil)
    (test-parseq 'nest-and-or '(b a) nil nil)
    (test-parseq 'nest-and-or '(a c) nil nil)
    (test-parseq 'nest-and-or '(b c) nil nil)
    (test-parseq 'nest-and-or '(a a d) t '(a a d))
    (test-parseq 'nest-and-or '(b a d) t '(b a d))
    (test-parseq 'nest-and-or '(a c d) t '(a c d))
    (test-parseq 'nest-and-or '(b c d) t '(b c d))
    (test-parseq 'nest-and-or '(a a e) t '(a a e))
    (test-parseq 'nest-and-or '(b a e) t '(b a e))
    (test-parseq 'nest-and-or '(a c e) t '(a c e))
    (test-parseq 'nest-and-or '(b c e) t '(b c e))

    ;; (* (and 'a 'b))
    (test-parseq 'nest-*-and '() t nil)
    (test-parseq 'nest-*-and '(a) nil nil)
    (test-parseq 'nest-*-and '(a) t nil t)
    (test-parseq 'nest-*-and '(a b) t)
    (test-parseq 'nest-*-and '(a b a) nil nil)
    (test-parseq 'nest-*-and '(a b a) t '((a b)) t)
    (test-parseq 'nest-*-and '(a b a b) t)

    ;; (and (* 'a 'b))
    (test-parseq 'nest-and-* '() t '(nil nil))
    (test-parseq 'nest-and-* '(a) t '((a) nil))
    (test-parseq 'nest-and-* '(a a) t '((a a) nil))
    (test-parseq 'nest-and-* '(b) t '(nil (b)))
    (test-parseq 'nest-and-* '(b b) t '(nil (b b)))
    (test-parseq 'nest-and-* '(a b) t '((a) (b)))
    (test-parseq 'nest-and-* '(a a b) t '((a a) (b)))
    (test-parseq 'nest-and-* '(a b b) t '((a) (b b)))

    ;; (+ (and 'a 'b))
    (test-parseq 'nest-+-and '() nil nil)
    (test-parseq 'nest-+-and '(a) nil nil)
    (test-parseq 'nest-+-and '(a b) t '((a b)))
    (test-parseq 'nest-+-and '(a b a) nil)
    (test-parseq 'nest-+-and '(a b a) t '((a b)) t)
    (test-parseq 'nest-+-and '(a b a b) t '((a b) (a b)))

    ;; (and (+ 'a 'b))
    (test-parseq 'nest-and-+ '() nil nil)
    (test-parseq 'nest-and-+ '(a) nil nil)
    (test-parseq 'nest-and-+ '(a a) nil nil)
    (test-parseq 'nest-and-+ '(b) nil nil)
    (test-parseq 'nest-and-+ '(b b) nil nil)
    (test-parseq 'nest-and-+ '(a b) t '((a) (b)))
    (test-parseq 'nest-and-+ '(a a b) t '((a a) (b)))
    (test-parseq 'nest-and-+ '(a b b) t '((a) (b b)))

    (test-parseq 'nest-list-list '(((a))) t '((a)))))

(define-test bind-test ()
  (check
    (test-parseq 'bind-single '(4 a a a) nil nil)
    (test-parseq 'bind-single '(4 a a a a) t '(4 (a a a a)))
    (test-parseq 'bind-single '(4 a a a a a) nil nil)
    (test-parseq 'bind-nest '(3 3 a a a 2 a a 7 a a a a a a a 1 a) nil nil)
    (test-parseq 'bind-nest '(4 3 a a a 2 a a 7 a a a a a a a 1 a) t '(4 ((3 (a a a)) (2 (a a)) (7 (a a a a a a a)) (1 (a)))))
    (test-parseq 'bind-nest '(5 3 a a a 2 a a 7 a a a a a a a 1 a) nil nil)
    (test-parseq 'bind-nest '(4 3 a a a 2 a a 6 a a a a a a a 1 a) nil nil)
    (test-parseq 'bind-nest '(4 3 a a a 2 a a 8 a a a a a a a 1 a) nil nil)))

(define-test local-rules-test ()
  (check
    (with-local-rules
      (defrule nonterminal-and () (and 'd 'e 'f))
      (test-parseq 'nonterminal-and '(a b c) nil nil)
      (test-parseq 'nonterminal-and '(d e f) t '(d e f)))))

(define-test recursion-test ()
  (check
    (test-parseq 'recursion '() nil nil)
    (test-parseq 'recursion '(a) t 'a)
    (test-parseq 'recursion '(a a) t '(a a))
    (test-parseq 'recursion '(a a a) t '(a (a a)))
    (test-parseq 'recursion '(a a a a) t '(a (a (a a))))
    (test-parseq 'recursion '(a a a a a) t '(a (a (a (a a)))))))

(define-test left-recursion-test ()
  (check
    (condition= (parseq 'left-recursion-indirect '(a a a)) simple-error)
    (condition= (parseq 'left-recursion '(a a a)) simple-error)))

(define-test loop-test ()
  (check
    (test-parseq 'loop '(named q for a from 0 below 10 by 10) t)
    (test-parseq 'loop '(named q for a from 0 above -10 by 10) t)
    (test-parseq 'loop '(named q for a downfrom 0 above 10 by 10) t)
    (test-parseq 'loop '(named q for a in lst by #'cdr) t)
    (test-parseq 'loop '(named q for a = 0 then (1+ a)) t)
    (test-parseq 'loop '(named q for a across vec) t)
    (test-parseq 'loop '(named q for k being the hash-key of (hsh) using (hash-value v)) t)
    (test-parseq 'loop '(named q for v being the hash-value of (hsh) using (hash-key v)) t)
    (test-parseq 'loop '(named q for k being the external-symbol of (pkg)) t)
    (test-parseq 'loop '(for i in lst initially a b c while d) t)
    (test-parseq 'loop '(for i in list repeat 5) t)
    (test-parseq 'loop '(for i in list thereis (> i 0)) t)
    (test-parseq 'loop '(for i across vec when (> i 0) collecting it into q and summing i into n else maximize i into m and return 5 end) t)
    (test-parseq 'loop '(for i across vec unless (minusp i) count i into q) t)))

(define-test parseq-test ()
  (check
    (terminal-test)
    (and-test)
    (and~-test)
    (or-test)
    (not-test)
    (*-test)
    (+-test)
    (?-test)
    (&-test)
    (!-test)
    (rep-test)
    (list-test)
    (string-test)
    (vector-test)
    (parameter-test)
    (option-test)
    (multiopt-test)
    (nesting-test)
    (bind-test)
    (local-rules-test)
    (recursion-test)
    (left-recursion-test)
    (loop-test)))
