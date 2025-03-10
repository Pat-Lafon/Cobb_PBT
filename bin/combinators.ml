let int_gen () = QCheck.Gen.int (QCheck_runner.random_state ())
let nat_gen () = QCheck.Gen.nat (QCheck_runner.random_state ())
let bool_gen () = QCheck.Gen.bool (QCheck_runner.random_state ())

(* re-implementing unit functions from Cobb *)
let sizecheck s = (s <= 0)
let subs s = s - 1
let list_mem l x = List.mem x l

(* for Err/ Exn *)
exception BailOut

(* int list gen of size s *)
let rec int_list_size_gen s =
  if s <= 0 then
    []
  else
    int_gen () :: int_list_size_gen (s - 1)

type 'a rbtree =
  | Rbtleaf
  | Rbtnode of bool * 'a rbtree * 'a  * 'a rbtree

let rec count_rbtree_nodes (t) : int =
  match t with
  | Rbtleaf -> 1
  | Rbtnode (_, l, _, r) -> 1 + count_rbtree_nodes l + count_rbtree_nodes r

(** This is our default rbtree generator *)
(* TODO: Somehow I would want a slight amount of variation in height here ... *)
let rec gen_sized_int_rbtree size =
  if size == 0 then
    Rbtleaf
  else
    let c = bool_gen () in
    let l = gen_sized_int_rbtree (subs size) in
    let v = int_gen () in
    let r = gen_sized_int_rbtree (subs size) in
    Rbtnode (c, l, v, r)

let gen_sized_int_root_red_rbtree size =
  if size == 0 then
    Rbtleaf
  else
    let c = true in
    let l = gen_sized_int_rbtree (subs size) in
    let v = int_gen () in
    let r = gen_sized_int_rbtree (subs size) in
    Rbtnode (c, l, v, r)


let rec num_black t h : bool =
  match t with
  | Rbtleaf -> h = 0
  | Rbtnode (c, l, _, r) ->
    if c then
      num_black l (h - 1) && num_black r (h - 1)
    else
      num_black l h && num_black r h

(* No red node has a red child *)
let rec no_red_red t : bool =
  match t with
  | Rbtleaf -> true
  | Rbtnode (c, l, _, r) ->
    if not c then
      no_red_red l && no_red_red r
    else (* c is true *)
      match l, r with
      | Rbtnode (c', _, _, _), Rbtnode (c'', _, _, _) -> not c' && not c'' && no_red_red l && no_red_red r
      | Rbtnode (c', _, _, _), Rbtleaf -> not c' && no_red_red l
      | Rbtleaf, Rbtnode (c'', _, _, _) -> not c'' && no_red_red r
      | Rbtleaf, Rbtleaf -> true

let rb_root_color t c : bool =
  match t with
  | Rbtleaf -> false
  | Rbtnode (c', _, _, _) -> c = c'

let rec rbtree_invariant t h : bool =
  match t with
  | Rbtleaf -> h = 0
  | Rbtnode (c, l, _, r) ->
    if not c then
      rbtree_invariant l (h-1) && rbtree_invariant r (h-1)
    else
      (not (rb_root_color l true) && not (rb_root_color r true)) &&
      rbtree_invariant l h && rbtree_invariant r h

let () = assert (
  rbtree_invariant (Rbtnode (true, Rbtleaf, 1, Rbtleaf)) 0
)

let () = assert (
  not (rbtree_invariant (Rbtnode (true, Rbtleaf, 1, Rbtleaf)) 1)
)

let () = assert (
  rbtree_invariant (Rbtnode (false, Rbtleaf, 1, Rbtleaf)) 1
)

let () = assert (
  rbtree_invariant (Rbtnode (false, Rbtnode (false, Rbtleaf, 1, Rbtleaf), 1, Rbtnode (false, Rbtleaf, 1, Rbtleaf))) 2
)

let () = assert (
  not (rbtree_invariant (Rbtnode (false, Rbtnode (false, Rbtleaf, 1, Rbtleaf), 1, Rbtnode (true, Rbtleaf, 1, Rbtleaf))) 2)
)

let () = assert (
  not (rbtree_invariant (Rbtnode (true, Rbtnode (true, Rbtleaf, 1, Rbtleaf), 1, Rbtnode (true, Rbtleaf, 1, Rbtleaf))) 0)
)

(* let rec heigh_inv t h : bool =
  match t with
  | Rbtleaf -> h = 0
  | Rbtnode (c, l, _, r) ->
    if c then
      heigh_inv l (h - 1) && heigh_inv r (h - 1)
    else
      heigh_inv l h && heigh_inv r h *)

(* let heigh_inv t h : bool =
  h >= 0 &&
  match t with
  | Rbtleaf -> h = 0
  | Rbtnode (c, l, _, r) ->
    if c then
      heigh_inv l (h - 1) && heigh_inv r (h - 1)
    else
      heigh_inv l h && heigh_inv r h *)

(* default int list gen with size s *)
(* achievable with as an a' arbitrary *)
let int_list_gen () =
  let size = nat_gen () in
  int_list_size_gen size

(* int list gen of size s or less *)
(* reminder: come back to this *)
let int_list_variable_size_gen () s =
  let size = Random.State.int (QCheck_runner.random_state ()) (s + 1) in
  int_list_size_gen size

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
