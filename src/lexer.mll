{
	open Parser

	let comment_buffer = ref ""
}

let eol = ['\r' '\n']
let whitespace = [' ' '\t']+
let coma = ','

let string = '"' [^'"']* '"'
let number = ['0'-'9']+('.'['0'-'9']+)?

rule main = parse
(* basic elements *)
	| eof			{EOF}
	| eol			{EOL}
	| coma			{COMA}
	| whitespace	{main lexbuf}
	
	| string as s 	{QUOTED_STRING s}
	| number as n 	{NUMBER n}

(* comments *)
(*
	| comment as c {COMMENT c}
*)
	| "'" [^'\n']* as c {COMMENT (String.sub c 1 ((String.length c) - 1))}
	|  "REM" [^'\n']* as c {COMMENT (String.sub c 3 ((String.length c) - 3))}
	| "/'" {comment_buffer := "";COMMENT_MULTI (comment_multi lexbuf)}
(* instructions *)
	| "LOCATE" {LOCATE}
	| "PRINT" {PRINT}
	| "SLEEP" {SLEEP}

	| _ as c {CHAR c}

and comment_multi = parse
	| "'/" {!comment_buffer}
	| eol as c {comment_buffer := (!comment_buffer ^ (String.make 1 c));comment_multi lexbuf}
	| _ as c {comment_buffer := (!comment_buffer ^ (String.make 1 c));comment_multi lexbuf}
