
%token COMA
%token EOF
%token EOL

%token <char> CHAR
%token <string> NUMBER
%token <string> QUOTED_STRING

%token LOCATE
%token PRINT
%token SLEEP

%start main
%type <unit> main
%%

main:
   includes headers lines footers EOF {}
;

lines:
    /* empty */ {}
  | lines line EOL {print_string ("\t"^$2^"\n")}
;

line:
	| {""}
	| PRINT QUOTED_STRING {"printf(" ^ $2 ^ ");"}
	/*| PRINT (STRING NUMBER)+ {print_string ("printf(" ^ $2 ^ ");\n")}*/
	| SLEEP {"getchar();"}
	| LOCATE NUMBER COMA NUMBER {"system(\"tput cup " ^ $2 ^ " " ^ $4 ^"\");"}

includes:
	| {print_string "#include <stdlib.h>\n\n"}
	
headers:
	| {print_string "void main()\n{\n"}
	
footers:
	| {print_string "}"}
