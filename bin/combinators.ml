(* random int generators are from qcheck 
  - allows test results to be consistent
  - shortcut for the function signature 
  I'll probably create my own version tho *)

let rec int_list_size_gen s st = 
  if s <= 0 then
    []
  else
    QCheck.Gen.int st :: int_list_size_gen (s - 1) st

(* int list sorted in ascending order *)
let rec int_list_sorted_gen prev s st = 
  if s <= 0 then
    []
  else
    let n = QCheck.Gen.int st in
    if n >= prev then
      n :: int_list_sorted_gen n (s - 1)st
    else 
      int_list_sorted_gen prev (s - 1) st

(* int list with each element identical *)
let int_list_dup_gen s st = 
  let n = QCheck.Gen.int st in
  let rec aux s' st' =
    if s' <= 0 then
      []
    else
        n :: aux (s' - 1) st' in
  aux s st

(* int list with each element unique *)
(* either dup or unique needs more work *)
let int_list_unique_gen s st = 
  let set = Hashtbl.create s in
  let rec aux s' st' =
    if s' <= 0 then
      []
    else
      let n = QCheck.Gen.int st' in
      (fun x -> Hashtbl.replace set x ()) n;
      if s' <> Hashtbl.length set then 
        n :: aux (s' - 1) st' else 
        aux (s' - 1) st' in
  aux s st

(* higher order programming *)
let list f = QCheck.make (fun st -> f (QCheck.Gen.nat st) st)

let int_list = list int_list_size_gen
let int_list_sorted = list (int_list_sorted_gen 0)
let int_list_dup = list int_list_dup_gen
let int_list_unique = list int_list_unique_gen

let gens = [int_list, int_list_sorted, int_list_dup]



