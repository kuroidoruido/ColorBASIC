EXEC = colorbasic

CAMLC = ocamlc
CAMLDEP = ocamldep
CAMLLEX = ocamllex
CAMLYACC = ocamlyacc

TESTS:=$(wildcard test/*.bas)

all: clean compile

compile:
	$(CAMLLEX) lexer.mll
	$(CAMLYACC) parser.mly
	$(CAMLC) -c parser.mli
	$(CAMLC) -c parser.ml
	$(CAMLC) -c lexer.ml
	$(CAMLC) *.cmo main.ml -o $(EXEC)

test: clean_test 
	./$(EXEC) test/print.bas
	./$(EXEC) test/two_print.bas
	./$(EXEC) test/locate.bas
	./$(EXEC) test/sleep.bas
	./$(EXEC) test/comment.bas
	./$(EXEC) test/dim.bas
	./$(EXEC) test/if.bas
	./$(EXEC) test/while.bas
	./$(EXEC) test/fibonacci.bas

clean:
	rm -f *.cm[iox] *.mli *~ .*~
	rm -rf lexer.ml parser.ml

clean_test:
	rm -f test/*.c

clean_all: clean clean_test
	rm -f ./$(EXEC)
