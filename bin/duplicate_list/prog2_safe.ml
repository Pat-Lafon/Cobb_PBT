open Combinators
(* had to remove rec here too *)
let duplicate_list_gen (s : int) (x : int) : int list =
  if sizecheck s then [] else x :: []