{
	open Parser

	let comment_buffer = ref ""
}

let eol = ['\r' '\n']
let whitespace = [' ' '\t']+
let coma = ','

let string = '"' [^'"']* '"'
let number = ['0'-'9']+('.'['0'-'9']+)?
let var_name = ['a'-'z''A'-'Z'](['a'-'z''A'-'Z''0'-'9''_']*)

rule main = parse
(* basic elements *)
	| eof			{EOF}
	| eol			{EOL}
	| coma			{COMA}
	| whitespace	{main lexbuf}
(* datatypes *)
	| "String"		{T_STRING}
	| "Integer"		{T_INTEGER}
(* comments *)
	| "'" [^'\n']* as c {COMMENT (String.sub c 1 ((String.length c) - 1))}
	|  "REM" [^'\n']* as c {COMMENT (String.sub c 3 ((String.length c) - 3))}
	| "/'" {comment_buffer := "";COMMENT_MULTI (comment_multi lexbuf)}
(* operators *)
	| '=' {OP_EQ}
	| '+' {OP_ADD}
	| '-' {OP_MIN}
	| '*' {OP_MUL}
	| '/' {OP_DIV}
	| '(' {OP_L_BRACKET}
	| ')' {OP_R_BRACKET}
(* instructions *)
	| "LOCATE" {LOCATE}
	| "PRINT" {PRINT}
	| "SLEEP" {SLEEP}
	| "DIM" {DIM}
	| "AS" {AS}
	
	| var_name as v	{VAR_NAME v}
	| string as s 	{QUOTED_STRING s}
	| number as n 	{NUMBER n}
	
	| _ as c {CHAR c}

and comment_multi = parse
	| "'/" {!comment_buffer}
	| eol as c {comment_buffer := (!comment_buffer ^ (String.make 1 c));comment_multi lexbuf}
	| _ as c {comment_buffer := (!comment_buffer ^ (String.make 1 c));comment_multi lexbuf}
