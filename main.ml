module A = Array
module L = List
module S = String
module Y = Sys

let (|.) (f : 'b -> 'c) (g : 'a -> 'b) : ('a -> 'c) = fun x -> f (g x)

let read : (unit -> string) =
    let line () : string option =
        try Some (input_line stdin) with End_of_file -> None in
    let rec loop (accu : string list) : (string option -> string list) =
        function
            | Some x -> loop (x::accu) (line ())
            | None -> L.rev accu in
    S.concat "\n" |. loop [] |. line

let main () =
    let lines = read () in
    let args = (S.concat " " |. A.to_list) Y.argv in
    L.iter print_endline [args; lines]

let () = main ()