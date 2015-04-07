%{
exception AlreadyDefined of string;;
let var_list :(string,string) Hashtbl.t = Hashtbl.create 10
(*
Hashtbl.add var_list key value
Hashtbl.find var_list key
*)

let dim_to_c_declaration basicType varName =
	match basicType with
	| "int"	-> ("int "^varName^";")
	| "string"	-> ("char* "^varName^";")
	| _ -> failwith basicType
;;

let printf_var varName =
	match Hashtbl.find var_list varName with
	| "int" -> ("\"%d\","^varName)
	| "string" ->("\"%s\","^varName)
	| _ -> failwith varName
;;
%}

%token COMA
%token EOF
%token EOL

%token <char> CHAR
%token <string> NUMBER
%token <string> QUOTED_STRING
%token <string> VAR_NAME
%token <string> COMMENT, COMMENT_MULTI

%token LOCATE
%token PRINT
%token SLEEP
%token DIM
%token AS

%token T_STRING, T_INTEGER

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
	| PRINT print_simple_arg end_of_line {"printf(" ^ $2 ^ ");"^$3}
	| SLEEP end_of_line {"getchar();\n"}
	| LOCATE NUMBER COMA NUMBER end_of_line {"system(\"tput cup " ^ $2 ^ " " ^ $4 ^"\");\n"}
	| DIM VAR_NAME AS datatype end_of_line {if Hashtbl.mem var_list $2 then raise (AlreadyDefined "This variable name was already used to defined another variable") else Hashtbl.add var_list $2 $4;(dim_to_c_declaration $4 $2)^$5}

print_simple_arg:
	| QUOTED_STRING {$1}
	| NUMBER {$1}

datatype:
	| T_STRING {"string"}
	| T_INTEGER {"int"}

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
