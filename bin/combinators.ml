let int_gen () = QCheck.Gen.int (QCheck_runner.random_state ())
let nat_gen () = QCheck.Gen.nat (QCheck_runner.random_state ())
let bool_gen () = QCheck.Gen.bool (QCheck_runner.random_state ())

(* re-implementing unit functions from Cobb *)
let sizecheck s = (s <= 0)
let subs s = s - 1
let list_mem l x = List.mem x l



(* default int list gen with size s *)
let int_list_gen () = 
  let size = nat_gen () in
  let rec aux s =
    if s <= 0 then
      []
    else
      int_gen () :: aux (s - 1) in
  aux size

(* int list gen of size s or less *)
let int_list_variable_size_gen () s =
  let size = Random.State.int (QCheck_runner.random_state ()) (s + 1) in 
  let rec aux s =
    if s <= 0 then
      []
    else
      int_gen () :: aux (s - 1) in
  aux size

(* int list sorted in ascending order *)
let int_list_sorted_gen () = 
  let start = int_gen () in
  let size = nat_gen () in
  let rec aux prev s =
    if s <= 0 then
      []
    else
      let n = int_gen () in
      if n >= prev then
        n :: aux n (s - 1)
      else 
        aux prev (s - 1) in
  aux start size

(* int list with each element identical *)
let int_list_dup_gen () = 
  let size = nat_gen () in
  let n = int_gen () in
  let rec aux s =
    if s <= 0 then
      []
    else
        n :: aux (s - 1) in
  aux size 

(* int list with each element unique *)
(* ignore, still in progress *)
let int_list_unique_gen () = 
  let size = nat_gen () in
  let set = Hashtbl.create size in
  let rec aux s len =
    if s <= 0 then
      []
    else
      let n = int_gen () in
      Hashtbl.replace set n ();
      if len <> Hashtbl.length set then 
        n :: aux (s - 1) (len + 1) else 
        aux (s - 1) len in
  aux size 1
  


