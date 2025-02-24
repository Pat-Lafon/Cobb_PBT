let int_gen () = QCheck.Gen.int (QCheck_runner.random_state ())
let nat_gen () = QCheck.Gen.nat (QCheck_runner.random_state ())
let bool_gen () = QCheck.Gen.bool (QCheck_runner.random_state ())

(* default int list gen with size s *)
(* achievable with as an a' arbitrary *)
let int_list_gen size () = 
  let s = size () in
  let rec aux s =
    if s <= 0 then
      []
    else
      int_gen () :: aux (s - 1) in
  aux s

(* looks like cobb synthesized generators *)
let rec int_list_gen' s =
  if s <= 0 then
    []
  else
    int_gen () :: int_list_gen' (s - 1)


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
  aux 0 size

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


let size_gen_wrapper f = f (nat_gen ())
  
(* higher order programming *)
(* make still expects random state as parameter, "_" gets rid of it *)
let arb_builder f = QCheck.make (fun _ -> f ())


let int_list = arb_builder (int_list_gen nat_gen)
let int_list_size = arb_builder int_list_variable_size_gen
let int_list_sorted = arb_builder int_list_sorted_gen
let int_list_dup = arb_builder int_list_dup_gen
let int_list_unique = arb_builder int_list_unique_gen




