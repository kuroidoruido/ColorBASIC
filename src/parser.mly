
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
  | lines line {print_string ("\t"^$2)}
;

line:
	| EOL{"\n"}
	| PRINT QUOTED_STRING EOL {"printf(" ^ $2 ^ ");\n"}
	/*| PRINT (STRING NUMBER)+ EOL {print_string ("printf(" ^ $2 ^ ");\n")}*/
	| SLEEP EOL {"getchar();\n"}
	| LOCATE NUMBER COMA NUMBER EOL {"system(\"tput cup " ^ $2 ^ " " ^ $4 ^"\");\n"}

includes:
	| {print_string "#include <stdlib.h>\n\n"}
	
headers:
	| {print_string "void main()\n{\n"}
	
footers:
	| {print_string "}"}
