open Combinators

(* had to take out x : int because it wasn't being used
  and remove rec
  is it a problem to break with the signature contintuity? *)
let duplicate_list_gen (s : int) : int list =
  if sizecheck s then [] else int_list_gen ()