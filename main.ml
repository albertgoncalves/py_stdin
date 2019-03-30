module A = Array
module L = List
module S = String
module Y = Sys

(*
 * https://www.youtube.com/watch?v=fCoQb-zqYDI
 *)

type world = World
type 'a io = (world -> ('a * world)) (* IO Transformer! *)

let (|.) (f : 'b -> 'c) (g : 'a -> 'b) : ('a -> 'c) = fun x -> f (g x)
let uncurry (f : ('a -> 'b -> 'c)) : (('a * 'b) -> 'c) = (fun (a, b) -> f a b)
let curry (f : (('a * 'b) -> 'c)) : ('a -> 'b -> 'c) = (fun a b -> f (a, b))

let touch_world (x : 'a) : 'a io = (fun io -> (x, io))

let read_pure : string io =
    let read : (unit -> string) =
        let line () : string option =
            try Some (input_line stdin) with End_of_file -> None in
        let rec loop (accu : string list) : (string option -> string list) =
            function
                | Some x -> loop (x::accu) (line ())
                | None -> L.rev accu in
        S.concat "\n" |. loop [] |. line in
    (touch_world |. read) ()

let print_pure (f : string -> unit) (s : string) : unit io =
    (touch_world |. f) s

let args_pure : string array io = touch_world Y.argv

let bind (m : 'a io) (f : 'a -> 'b io) : 'b io = uncurry f |. m
let (>>=) : ('a io -> ('a -> 'b io) -> 'b io) = bind

let interact : unit io =
    read_pure >>= (fun lines ->
        args_pure >>= (fun args ->
            let all_input =
                S.concat "\n" [(S.concat " " |. A.to_list) args; lines] in
            (print_pure print_endline all_input)))

let world_to_void (f : unit io) : unit = ((fun _ -> ()) |. f) World

let main () = interact |> world_to_void

let () = main ()
