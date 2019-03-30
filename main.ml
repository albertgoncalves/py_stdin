module A = Array
module L = List
module S = String

let (|.) (f : 'b -> 'c) (g : 'a -> 'b) : ('a -> 'c) = fun x -> f (g x)

let read () : string =
    let next_line () : string option =
        try Some (input_line stdin) with End_of_file -> None in
    let rec loop (accu : string list) : (string option -> string list) =
        function
            | Some x -> loop (x::accu) (next_line ())
            | None -> L.rev accu in
    loop [] (next_line ()) |> S.concat "\n"

let main () =
    let lines = read () in
    let args = (S.concat " " |. A.to_list) Sys.argv in
    L.iter print_endline [args; lines]

let () = main ()
