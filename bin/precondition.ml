open Combinators

(* preconditions for list *)
let is_sized (n, l) = List.length l <= n
let has_same_size (s, l) = List.length l = s
let is_empty l = l = []
let if_head_map_f_else_true f = function h :: t -> f h | _ -> true

let rec is_sorted = function
  | h1 :: h2 :: t -> if h1 <= h2 then is_sorted (h2 :: t) else false
  | _ -> true

let rec is_duplicate = function
  | h1 :: h2 :: t -> if h1 = h2 then is_duplicate (h2 :: t) else false
  | _ -> true

let is_unique l =
  let len = List.length l in
  let set = Hashtbl.create len in
  let () = List.iter (fun x -> Hashtbl.replace set x ()) l in
  len = Hashtbl.length set

(* units for filter functions *)

let rec has_duplicate_int_x l x =
  match l with [] -> true | h :: t -> h = x && has_duplicate_int_x t x
