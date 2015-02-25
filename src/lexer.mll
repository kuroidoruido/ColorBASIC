{
 open Parser
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

(* instructions *)
	| "LOCATE" {LOCATE}
	| "PRINT" {PRINT}
	| "SLEEP" {SLEEP}

	| _ as c {CHAR c}
