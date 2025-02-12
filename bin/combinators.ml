Random.init 2025

let rec int_list_size_gen s st = 
  if s <= 0 then
    []
  else
    QCheck.Gen.int st :: int_list_size_gen (s - 1) st

let int_list_gen st = int_list_size_gen (QCheck.Gen.nat st) st

let int_list = QCheck.make (int_list_gen)

let rec print_list l = match l with 
| [] -> print_newline ()
| h ::t -> print_int h; print_char ' '; print_list t



