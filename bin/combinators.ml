(* random int generators are from qcheck 
  - allows test results to be consistent
  - shortcut for the function signature 
  I'll probably create my own version tho *)

(* trying to abstract away random state, not sure what
intentions are, will ask for clarification on Monday *)
let st = ref (Random.State.make [| 0 |])

let int_gen = QCheck.Gen.int !st
let bool_gen = QCheck.Gen.bool !st

(* removed st parameter *)
(* default int list gen with size s*)
let rec int_list_size_gen s = 
  if s <= 0 then
    []
  else
    (* using st initialized in ref *)
    QCheck.Gen.int !st :: int_list_size_gen (s - 1)

(* default int list gen with random size 
  defining list_gen causes a stack overflow (???)
  list_gen is not called *)
(* let list_gen = int_list_size_gen int_gen *)

(* int list gen of size s or less*)
let int_list_variable_size_gen s =
  let s' = Random.State.int !st (s + 1) in 
    int_list_size_gen s'

(* int list sorted in ascending order *)
let rec int_list_sorted_gen prev s = 
  if s <= 0 then
    []
  else
    let n = int_gen in
    if n >= prev then
      n :: int_list_sorted_gen n (s - 1)
    else 
      int_list_sorted_gen prev (s - 1)

(* int list with each element identical *)
let int_list_dup_gen s = 
  let n = int_gen in
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
(* uses QCheck.Gen.nat for random size of list *)
(* make still expects random state as parameter, "_" gets rid of it*)
let arb_builer f = QCheck.make (fun _ -> f (QCheck.Gen.nat !st) )
let arb_builer' f = QCheck.make (fun _ -> f)


let int_list = arb_builer int_list_size_gen
let int_list_variable_size = arb_builer int_list_variable_size_gen
let int_list_sorted = arb_builer (int_list_sorted_gen 0)
let int_list_dup = arb_builer int_list_dup_gen
let int_list_unique = arb_builer int_list_unique_gen

let gens = [int_list, int_list_sorted, int_list_dup]



