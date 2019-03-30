module A = Array
module L = List
module S = String
module Y = Sys

(*
 * https://www.youtube.com/watch?v=fCoQb-zqYDI
 *)

type world = World
type 'a io = ('a * world)
type 'a io_t = (world -> 'a io) (* IO Transformer! *)

let (|.) (f : 'b -> 'c) (g : 'a -> 'b) : ('a -> 'c) = fun x -> f (g x)
let uncurry (f : ('a -> 'b -> 'c)) : (('a * 'b) -> 'c) = (fun (a, b) -> f a b)
let curry (f : (('a * 'b) -> 'c)) : ('a -> 'b -> 'c) = (fun a b -> f (a, b))

let read_pure (io : world) : string io =
    let read : (unit -> string) =
        let line () : string option =
            try Some (input_line stdin) with End_of_file -> None in
        let rec loop (accu : string list) : (string option -> string list) =
            function
                | Some x -> loop (x::accu) (line ())
                | None -> L.rev accu in
        S.concat "\n" |. loop [] |. line in
    (read (), io)

let print_pure (f : string -> unit) (s : string) (io : world) : unit io =
    (f s, io)

let args_pure (io : world) : string array io = (Y.argv, io)

let bind (m : 'a io_t) (f : 'a -> 'b io_t) : 'b io_t = uncurry f |. m
let (>>=) : ('a io_t -> ('a -> 'b io_t) -> 'b io_t) = bind

let perform_io : unit io_t =
    read_pure >>= (fun lines ->
        args_pure >>= (fun args ->
            let all_input =
                S.concat "\n" [(S.concat " " |. A.to_list) args; lines] in
            (print_pure print_endline all_input)))

let io_to_void (f : unit io_t) : unit = ((fun _ -> ()) |. f) World

let main () = perform_io |> io_to_void

let () = main ()
