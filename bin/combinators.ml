(* random int generators are from qcheck 
  - allows test results to be consistent
  - shortcut for the function signature 
  I'll probably create my own version tho *)

(* trying to abstract away random state, not sure what
intentions are, will ask for clarification on Monday *)
let st = ref (Random.State.make [| 2100 |])

(* removed st parameter *)
let rec int_list_size_gen s = 
  if s <= 0 then
    []
  else
    (* using st initialized in ref *)
    QCheck.Gen.int !st :: int_list_size_gen (s - 1)

(* int list sorted in ascending order *)
let rec int_list_sorted_gen prev s = 
  if s <= 0 then
    []
  else
    let n = QCheck.Gen.int !st in
    if n >= prev then
      n :: int_list_sorted_gen n (s - 1)
    else 
      int_list_sorted_gen prev (s - 1)

(* int list with each element identical *)
let int_list_dup_gen s = 
  let n = QCheck.Gen.int !st in
  let rec aux s' =
    if s' <= 0 then
      []
    else
        n :: aux (s' - 1) in
  aux s 

(* int list with each element unique *)
(* ignore, still in progress *)
let int_list_unique_gen s = 
  let set = Hashtbl.create s in
  let rec aux s' len =
    if s' <= 0 then
      []
    else
      let n = QCheck.Gen.int !st in
      Hashtbl.replace set n ();
      if len <> Hashtbl.length set then 
        n :: aux (s' - 1) (len + 1) else 
        aux (s' - 1) len in
  aux s 1

(* higher order programming *)
(* make still expects random state as parameter, "_" gets rid of it*)
let list f = QCheck.make (fun _ -> f (QCheck.Gen.nat !st) )

let int_list = list int_list_size_gen
let int_list_sorted = list (int_list_sorted_gen 0)
let int_list_dup = list int_list_dup_gen
let int_list_unique = list int_list_unique_gen

let gens = [int_list, int_list_sorted, int_list_dup]



