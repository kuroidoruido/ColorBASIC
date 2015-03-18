
%token COMA
%token EOF
%token EOL

%token <char> CHAR
%token <string> NUMBER
%token <string> QUOTED_STRING
%token <string> COMMENT, COMMENT_MULTI

%token LOCATE
%token PRINT
%token SLEEP

%start main
%type <unit> main
%%

main:
   includes headers insts footers EOF {}
;

insts:
    /* empty */ {}
  | insts inst {print_string ("\t"^$2)}
;

inst:
	| end_of_line {$1}
	| PRINT QUOTED_STRING end_of_line {"printf(" ^ $2 ^ ");"^$3}
	
	| SLEEP end_of_line {"getchar();\n"}
	| LOCATE NUMBER COMA NUMBER end_of_line {"system(\"tput cup " ^ $2 ^ " " ^ $4 ^"\");\n"}
	| COMMENT EOL {"//"^$1^"\n"}
	| COMMENT_MULTI EOL {"/*"^$1^"*/\n"}

end_of_line:
	| EOL {"\n"}
	| COMMENT EOL {"// "^$1^"\n"}
	| COMMENT_MULTI EOL {"/* "^$1^"*/\n"}

includes:
	| {print_string "#include <stdlib.h>\n\n"}
	
headers:
	| {print_string "void main()\n{\n"}
	
footers:
	| {print_string "}"}
