EXEC = colorbasic

CAMLC = ocamlc
CAMLDEP = ocamldep
CAMLLEX = ocamllex
CAMLYACC = ocamlyacc

TESTS:=$(wildcard ../test/*.bas)

all: clean compile

compile:
	$(CAMLLEX) lexer.mll
	$(CAMLYACC) parser.mly
	$(CAMLC) -c parser.mli
	$(CAMLC) -c parser.ml
	$(CAMLC) -c lexer.ml
	$(CAMLC) *.cmo main.ml -o $(EXEC)

test: 
	./$(EXEC) ../test/print.bas
	@echo
	./$(EXEC) ../test/two_print.bas
	@echo
	./$(EXEC) ../test/locate.bas
	@echo
	./$(EXEC) ../test/sleep.bas
	@echo
	./$(EXEC) ../test/comment.bas
	@echo
clean:
	rm -f *.cm[iox] *.mli *~ .*~
	rm -rf lexer.ml parser.ml
