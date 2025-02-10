Random.init 2025

let rec int_list s = 
  if s <= 0 then
    []
  else
    Random.int 100000 :: int_list (s - 1)

let rec print_list l = match l with 
| [] -> print_newline ()
| h ::t -> print_int h; print_char ' '; print_list t



