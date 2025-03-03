open Combinators

(* higher order programming *)
(* make still expects random state as parameter, "_" gets rid of it *)
let arb_builder f = QCheck.make (fun _ -> f ())

(* my generators *)
let int = arb_builder int_gen
let int_list = arb_builder int_list_gen
let int_list_size = arb_builder int_list_variable_size_gen
let int_list_sorted = arb_builder int_list_sorted_gen
let int_list_dup = arb_builder int_list_dup_gen
let int_list_unique = arb_builder int_list_unique_gen

(* input wrappers for Cobb generators *)
let pair_size f () = 
  let size = nat_gen () in
  (size, f size)

let size_wrapper f () =
  let x = nat_gen () in 
  f x

let size_int_wrapper f () =
  let x1 = nat_gen () in
  let x2 = int_gen () in
  f x1 x2

(* Cobb synthesized generators *)

(* sized lists *)
let sized_list_generators = 
  [ (Sized_list.Prog.sized_list_gen, "prog") ; 
  (Sized_list.Prog1_syn_edit.sized_list_gen, "prog1_syn") ; (Sized_list.Prog2_syn_edit.sized_list_gen, "prog2_syn") ; (Sized_list.Prog3_syn.sized_list_gen, "prog3_syn") ;
  (Sized_list.Prog1_cov.sized_list_gen, "prog1_cov") ; (Sized_list.Prog2_cov.sized_list_gen , "prog2_cov")  ; (Sized_list.Prog3_cov.sized_list_gen , "prog3_cov") ; 
  (Sized_list.Prog1_safe.sized_list_gen , "prog1_syn")  ; (Sized_list.Prog2_safe.sized_list_gen , "prog2_syn") ; (Sized_list.Prog3_safe.sized_list_gen , "prog3_syn") ]

(* duplicate lists *)
let duplicate_list = arb_builder (size_int_wrapper Duplicate_list.Prog.duplicate_list_gen)
(* synthesized *)
let duplicate_list_prog1_syn = arb_builder (size_int_wrapper Duplicate_list.Prog1_syn_edit.duplicate_list_gen)
let duplicate_list_prog2_syn = arb_builder (size_int_wrapper Duplicate_list.Prog2_syn_edit.duplicate_list_gen)
(* coverage-only *)
let duplicate_list_prog1_cov = arb_builder (size_int_wrapper Duplicate_list.Prog1_cov.duplicate_list_gen)
let duplicate_list_prog2_cov = arb_builder (size_int_wrapper Duplicate_list.Prog2_cov.duplicate_list_gen)
(* safe-only *)
let duplicate_list_prog1_safe = arb_builder (size_int_wrapper Duplicate_list.Prog1_safe.duplicate_list_gen)
let duplicate_list_prog2_safe = arb_builder (size_int_wrapper Duplicate_list.Prog1_safe.duplicate_list_gen)


(* Cobb synthesized generators *)

(* sized lists *)
let sized_list_generators = 
  [ (Sized_list.Prog.sized_list_gen, "prog") ; 
  (Sized_list.Prog1_syn_edit.sized_list_gen, "prog1_syn") ; (Sized_list.Prog2_syn_edit.sized_list_gen, "prog2_syn") ; (Sized_list.Prog3_syn.sized_list_gen, "prog3_syn") ;
  (Sized_list.Prog1_cov.sized_list_gen, "prog1_cov") ; (Sized_list.Prog2_cov.sized_list_gen , "prog2_cov")  ; (Sized_list.Prog3_cov.sized_list_gen , "prog3_cov") ; 
  (Sized_list.Prog1_safe.sized_list_gen , "prog1_syn")  ; (Sized_list.Prog2_safe.sized_list_gen , "prog2_syn") ; (Sized_list.Prog3_safe.sized_list_gen , "prog3_syn") ]

(* duplicate lists *)
let duplicate_list_generators = 
  [ (Duplicate_list.Prog.duplicate_list_gen, "prog") ;
  (Duplicate_list.Prog1_syn_edit.duplicate_list_gen, "prog1_syn") ; (Duplicate_list.Prog2_syn_edit.duplicate_list_gen, "prog2_syn") ; 
  (Duplicate_list.Prog1_cov.duplicate_list_gen, "prog1_cov") ; (Duplicate_list.Prog2_cov.duplicate_list_gen, "prog2_cov") ;
  (Duplicate_list.Prog1_safe.duplicate_list_gen, "prog1_safe") ; (Duplicate_list.Prog2_safe.duplicate_list_gen, "prog2_safe") ]

(* Unique lists *)
let unique_list_generators = 
  [ (Unique_list.Prog.unique_list_gen, "prog") ; 
  (Unique_list.Prog1_syn.unique_list_gen, "prog1_syn") ; (Unique_list.Prog2_syn.unique_list_gen, "prog2_syn") ; (Unique_list.Prog3_syn.unique_list_gen, "prog3_syn") ; 
  (Unique_list.Prog1_cov.unique_list_gen, "prog1_cov") ; (Unique_list.Prog2_cov.unique_list_gen, "prog2_cov") ; (Unique_list.Prog3_cov.unique_list_gen, "prog3_cov") ; 
  (Unique_list.Prog1_safe.unique_list_gen, "prog1_safe") ; (Unique_list.Prog2_safe.unique_list_gen, "prog2_safe") ; (Unique_list.Prog3_safe.unique_list_gen, "prog3_safe") ;]

(* sorted lists *)
let sorted_list_generators =
  [ (Sorted_list.Prog.sorted_list_gen, "prog") ;
  (Sorted_list.Prog1_syn.sorted_list_gen, "prog1_syn") ; (Sorted_list.Prog2_syn.sorted_list_gen, "prog2_syn") ; (Sorted_list.Prog3_syn.sorted_list_gen, "prog3_syn") ;
  (Sorted_list.Prog1_cov.sorted_list_gen, "prog1_cov") ; (Sorted_list.Prog2_cov.sorted_list_gen, "prog2_cov") ; (Sorted_list.Prog3_cov.sorted_list_gen, "prog3_cov") ;
  (Sorted_list.Prog1_safe.sorted_list_gen, "prog1_safe") ; (Sorted_list.Prog2_safe.sorted_list_gen, "prog2_safe") ; (Sorted_list.Prog3_safe.sorted_list_gen, "prog3_safe") ;]

(* arbitary values for generator *)
(* let sized_list_arbitraries = List.map (fun (gen, name) -> (fun x -> arb_builder' (gen x)), name) sized_list_generators *)
let sized_list_arbitraries = List.map (fun (gen, name) -> arb_builder (pair_size gen), name) sized_list_generators
let duplicate_list_arbitraries = List.map (fun (gen, name) -> (arb_builder (size_int_wrapper gen), name)) duplicate_list_generators
let unique_list_arbitraries = List.map (fun (gen, name) -> (arb_builder (size_wrapper gen), name)) unique_list_generators
let sorted_list_arbitraries = List.map (fun (gen, name) -> (arb_builder (size_int_wrapper gen), name)) sorted_list_generators

let example = arb_builder (pair_size Sized_list.Prog.sized_list_gen)
