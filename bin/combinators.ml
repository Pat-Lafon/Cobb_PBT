(* random int generators are from qcheck *)
let st = ref (Random.State.make [| 24738 |])
let st' = ref None
let seed = 0

let set_st = let state = Random.State.make [| seed |] in
  st' := Some state;
  state

let get_st st = match !st with
| Some s -> s
| None -> set_st

let int_gen = QCheck.Gen.int (get_st st')
let bool_gen = QCheck.Gen.bool (get_st st')

(* removed st parameter *)
(* default int list gen with size s*)
let rec int_list_gen s = 
  if s <= 0 then
    []
  else
    (* using st initialized in ref *)
  int_gen :: int_list_gen (s - 1)

(* default int list gen with random size 
  defining list_gen causes a stack overflow (???)
  list_gen is not called *)
(* let list_gen = int_list_size_gen int_gen *)

(* int list gen of size s or less*)
let int_list_variable_size_gen s =
  let s' = Random.State.int !st (s + 1) in 
    int_list_gen s'

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
      let n = int_gen in
      Hashtbl.replace set n ();
      if len <> Hashtbl.length set then 
        n :: aux (s' - 1) (len + 1) else 
        aux (s' - 1) len in
  aux s 1


let size_gen_wrapper f = f (QCheck.Gen.nat !st)
  
(* higher order programming *)
(* uses QCheck.Gen.nat for random size of list *)
(* make still expects random state as parameter, "_" gets rid of it*)
let arb_builer f = QCheck.make (fun _ -> f (QCheck.Gen.nat !st) )
let arb_builer' f = QCheck.make (fun _ -> f)


let int_list = arb_builer' (size_gen_wrapper int_list_gen)
let int_list_variable_size = arb_builer int_list_variable_size_gen
let int_list_sorted = arb_builer (int_list_sorted_gen 0)
let int_list_dup = arb_builer int_list_dup_gen
let int_list_unique = arb_builer int_list_unique_gen




