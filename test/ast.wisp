(ns wisp.test.ast
  (:require [wisp.src.reader :refer [read-from-string]]
            [wisp.src.sequence :refer [list]]
            [wisp.src.runtime :refer [str =]]
            [wisp.src.ast :refer [name gensym symbol? symbol keyword? keyword
                                  quote? quote syntax-quote? syntax-quote]]))

(def read-string read-from-string)

(print "test gensym")

(assert (symbol? (gensym))
        "gensym generates symbol")
(assert (identical? (.substr (name (gensym)) 0 3) "G__")
        "global symbols are prefixed with 'G__'")
(assert (not (identical? (name (gensym)) (name (gensym))))
        "gensym generates unique symbol each time")
(assert (identical? (.substr (name (gensym "foo")) 0 3) "foo")
        "if prefix is given symbol is prefixed with it")
(assert (not (identical? (name (gensym "p")) (name (gensym "p"))))
        "gensym generates unique symbol even if prefixed")

(print "test quote?")

(assert (quote? (read-string "'()")) "'() is quoted list")
(assert (not (quote? (read-string "`()"))) "'() is not quoted list")
(assert (not (quote? (read-string "()"))) "() is not quoted list")

(assert (quote? (read-string "'foo")) "'foo is quoted symbol")
(assert (not (quote? (read-string "foo"))) "foo symbol is not quoted")


(print "test syntax-quote?")

(assert (syntax-quote? (read-string "`()")) "`() is syntax quoted list")
(assert (not (syntax-quote?
              (read-string "'()"))) "'() is not syntax quoted list")

(assert (not (syntax-quote?
              (read-string "()"))) "() is not syntax quoted list")
(assert (syntax-quote? (read-string "`foo")) "`foo is syntax quoted symbol")
(assert (not (syntax-quote?
              (read-string "'foo"))) "'foo symbol is not syntax quoted")
(assert (not (syntax-quote?
              (read-string "foo"))) "foo symbol is not syntax quoted")

(print "symbol tests")


(assert (symbol? (symbol "foo")))
(assert (symbol? (symbol "/")))
(assert (symbol? (symbol "")))
(assert (symbol? (symbol "foo" "bar")))

(assert (= "foo" (name (symbol "foo"))))
(assert (= "/" (name (symbol "/"))))
; TODO: fix
; (assert (= "" (name (symbol ""))))
(assert (= "bar" (name (symbol "foo" "bar"))))
