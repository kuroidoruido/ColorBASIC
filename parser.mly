%{
exception VariableException of string;;
let var_list :(string,string) Hashtbl.t = Hashtbl.create 10
(*
Hashtbl.add var_list key value
Hashtbl.find var_list key
*)

let dim_to_c_declaration_init basicType varName init=
	match basicType with
	| "int"	-> ("int "^varName^" = "^init^";")
	| "string"	-> ("char* "^varName^" = "^init^";")
	| _ -> failwith basicType
;;

let dim_to_c_declaration basicType varName =
	match basicType with
	| "int"	-> (dim_to_c_declaration_init basicType varName "0")
	| "string"	-> (dim_to_c_declaration_init basicType varName "\"\"")
	| _ -> failwith basicType
;;

let printf_var varName =
	let local varName =
		match Hashtbl.find var_list varName with
		| "int" -> ("\"%d\\n\","^varName)
		| "string" ->("\"%s\\n\","^varName)
		| _ -> failwith varName
	in "printf("^(local varName)^");"
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

%token OP_EQ, OP_ADD, OP_MIN, OP_MUL, OP_DIV
%token OP_NOTEQ, OP_SUP, OP_SUPEQ, OP_INF, OP_INFEQ
%token OP_L_BRACKET, OP_R_BRACKET

%token LOCATE
%token PRINT
%token SLEEP
%token DIM, AS

%token IF, THEN, ELSE, ELSEIF, ENDIF
%token WHILE, WEND

%token T_STRING, T_INTEGER

%start main
%type <string> main
%%

main:
   includes headers insts footers EOF {$1^$2^$3^$4}
;

insts:
    /* empty */ {""}
  | insts inst {$1^"\t"^$2}
;

inst:
	| end_of_line {$1}
/* PRINT */
	| PRINT print_simple_arg end_of_line {"printf(" ^ $2 ^ ");"^$3}
	| PRINT VAR_NAME end_of_line {
		if Hashtbl.mem var_list $2
		then
			(printf_var $2)^$3
		else
			raise (VariableException "No previous declaration of this variable")
		}
/* SLEEP */
	| SLEEP end_of_line {"getchar();"^$2}
/* LOCATE */
	| LOCATE NUMBER COMA NUMBER end_of_line {"system(\"tput cup " ^ $2 ^ " " ^ $4 ^"\");"^$5}
/* DIM */
	/* simple */
	| DIM VAR_NAME AS datatype end_of_line {
		if Hashtbl.mem var_list $2
		then
			raise (VariableException "This variable name was already used to defined another variable")
		else Hashtbl.add var_list $2 $4;
			(dim_to_c_declaration $4 $2)^$5
		}
	/* affectation number */
	| DIM VAR_NAME AS datatype OP_EQ expression end_of_line {
		if Hashtbl.mem var_list $2
		then
			raise (VariableException "This variable name was already used to defined another variable")
		else Hashtbl.add var_list $2 $4;
			if $4 = "int"
			then
				(dim_to_c_declaration_init $4 $2 $6)^$7
			else
				raise (VariableException "Incompatible type")
		}
	/* affectation string */
	| DIM VAR_NAME AS datatype OP_EQ QUOTED_STRING end_of_line {
		if Hashtbl.mem var_list $2
		then
			raise (VariableException "This variable name was already used to defined another variable")
		else Hashtbl.add var_list $2 $4;
			if $4 = "string"
			then
				(dim_to_c_declaration_init $4 $2 $6)^$7
			else
				raise (VariableException "Incompatible type")
		}
/* AFFECTATION */
	/* number */
	| VAR_NAME OP_EQ expression end_of_line {
			if Hashtbl.mem var_list $1
			then
				if Hashtbl.find var_list $1 = "int"
				then
					$1^"="^$3^";"^$4
				else
					raise (VariableException "Incompatible type")
			else
				raise (VariableException "No previous declaration of this variable")
		}
	/* string */
	| VAR_NAME OP_EQ QUOTED_STRING end_of_line {
			if Hashtbl.mem var_list $1
			then
				if Hashtbl.find var_list $1 = "string"
				then
					$1^"="^$3^";"^$4
				else
					raise (VariableException "Incompatible type")
			else
				raise (VariableException "No previous declaration of this variable")
		}
/* CONTROL STRUCTURE */
	/* if */
	| IF boolean_expression THEN insts ifelse ENDIF end_of_line {"if("^$2^")\n\t{"^$4^$5^"\t}"^$7}
	/* while */
	| WHILE boolean_expression end_of_line insts WEND end_of_line {"while("^$2^")"^$3^"\t{\n"^$4^"\t}"^$6}


ifelse:
	| /*empty*/ {""}
	| ELSE insts {"\t}\n\telse\n\t{"^$2}
	| ELSEIF boolean_expression THEN insts ifelse {"\t}\n\telse if("^$2^")\n\t{"^$4^$5}

print_simple_arg:
	| QUOTED_STRING {"\"%s\\n\","^$1}
	| NUMBER {"\"%d\\n\","^$1}

expression:
	| number {$1}
	| OP_MIN number {"-"^$2}
	| OP_L_BRACKET expression OP_R_BRACKET {"("^$2^")"}
	| OP_L_BRACKET expression OP_R_BRACKET operators expression {"("^$2^")"^$4^$5}
	| number operators expression {$1^$2^$3}

boolean_expression:
	| NUMBER comparison_operator NUMBER {$1^" "^$2^" "^$3}
	| VAR_NAME comparison_operator NUMBER {$1^" "^$2^" "^$3}
	| NUMBER comparison_operator VAR_NAME {$1^" "^$2^" "^$3}
	
	| QUOTED_STRING OP_EQ QUOTED_STRING {"strcmp("^$1^","^$3^")"}
	| VAR_NAME OP_EQ QUOTED_STRING {"strcmp("^$1^","^$3^")"}
	| QUOTED_STRING OP_EQ VAR_NAME {"strcmp("^$1^","^$3^")"}

	| VAR_NAME comparison_operator VAR_NAME {
		if Hashtbl.find var_list $1 = "string"
		then
			if $2 = "==" && Hashtbl.find var_list $1 = "string"
			then
				"strcmp("^$1^","^$3^")"
			else
				raise (VariableException "Incompatible type for this comparison operator")
		else
			$1^" "^$2^" "^$3
		}
	
operators:
	| OP_ADD		{"+"}
	| OP_MIN		{"-"}
	| OP_MUL		{"*"}
	| OP_DIV		{"/"}
	
comparison_operator:
	| OP_EQ			{"=="}
	| OP_NOTEQ		{"!="}
	| OP_SUP		{">"}
	| OP_SUPEQ		{">="}
	| OP_INF		{"<"}
	| OP_INFEQ		{"<="}

number:
	| NUMBER {$1}
	| VAR_NAME {
		if Hashtbl.find var_list $1 = "int"
		then
			$1
		else
			raise (VariableException "Incompatible type for an expression")
		}

datatype:
	| T_STRING {"string"}
	| T_INTEGER {"int"}

end_of_line:
	| EOL {"\n"}
	| COMMENT EOL {"// "^$1^"\n"}
	| COMMENT_MULTI EOL {"/* "^$1^"*/\n"}

includes:
	| {"#include <stdlib.h>\n#include <stdio.h>\n\n"}
	
headers:
	| {"void main()\n{\n"}
	
footers:
	| {"}"}
