open Parser

(* Main *)
let () =
	if Array.length Sys.argv < 2 then
		print_endline "Please, give a file name"
	else
		let input_file = Sys.argv.(1) in
		if not (Sys.file_exists input_file) then
			print_endline "This file does not exist"
		else
			let lexbuf = Lexing.from_channel (open_in input_file)
			and file = open_out ((String.sub Sys.argv.(1) 0 (String.rindex Sys.argv.(1) '.'))^".c")
			in output_string file (Parser.main Lexer.main lexbuf)
