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

test: all
	./$(EXEC) test/print.bas
	@echo -e "\n"
	./$(EXEC) test/two_print.bas
	@echo -e "\n"
	./$(EXEC) test/locate.bas
	@echo -e "\n"
	./$(EXEC) test/sleep.bas
	@echo -e "\n"
	./$(EXEC) test/comment.bas
	@echo -e "\n"
	./$(EXEC) test/dim.bas
	@echo -e "\n"
	./$(EXEC) test/if.bas
	@echo -e "\n"

clean:
	rm -f *.cm[iox] *.mli *~ .*~
	rm -rf lexer.ml parser.ml
