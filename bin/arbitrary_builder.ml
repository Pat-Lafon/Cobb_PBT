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

(* dealing with exception Bailout *)
let catch_err f (s : int) (x : int) (*: 'a option list*) =
  try Some (f s x) with
    | BailOut -> None


(* Cobb synthesized generators *)

(* sized lists *)
let sized_list_generators = 
  [ (Sized_list.Prog.sized_list_gen, "prog") ; 
  (Sized_list.Prog1_syn.sized_list_gen, "prog1_syn") ; (Sized_list.Prog2_syn.sized_list_gen, "prog2_syn") ; (Sized_list.Prog3_syn.sized_list_gen, "prog3_syn") ;
  (Sized_list.Prog4_syn.sized_list_gen, "prog4_syn") ; (Sized_list.Prog5_syn.sized_list_gen, "prog5_syn") ; (Sized_list.Prog6_syn.sized_list_gen, "prog6_syn") ;
  (Sized_list.Prog8_syn.sized_list_gen, "prog7_syn") ; (Sized_list.Prog8_syn.sized_list_gen, "prog8_syn") ; (Sized_list.Prog9_syn.sized_list_gen, "prog9_syn") ;
  (Sized_list.Prog1_cov.sized_list_gen, "prog1_cov") ; (Sized_list.Prog2_cov.sized_list_gen , "prog2_cov")  ; (Sized_list.Prog3_cov.sized_list_gen , "prog3_cov") ; 
  (Sized_list.Prog4_cov.sized_list_gen, "prog4_cov") ; (Sized_list.Prog5_cov.sized_list_gen , "prog5_cov")  ; (Sized_list.Prog6_cov.sized_list_gen , "prog6_cov") ; 
  (Sized_list.Prog7_cov.sized_list_gen, "prog7_cov") ; (Sized_list.Prog8_cov.sized_list_gen , "prog8_cov")  ; (Sized_list.Prog9_cov.sized_list_gen , "prog9_cov") ; 
  (Sized_list.Prog1_safe.sized_list_gen , "prog1_syn")  ; (Sized_list.Prog2_safe.sized_list_gen , "prog2_syn") ; (Sized_list.Prog3_safe.sized_list_gen , "prog3_syn") ;
  (Sized_list.Prog4_safe.sized_list_gen , "prog4_syn")  ; (Sized_list.Prog5_safe.sized_list_gen , "prog5_syn") ; (Sized_list.Prog6_safe.sized_list_gen , "prog6_syn") ;
  (Sized_list.Prog7_safe.sized_list_gen , "prog7_syn")  ; (Sized_list.Prog8_safe.sized_list_gen , "prog8_syn") ; (Sized_list.Prog9_safe.sized_list_gen , "prog9_syn") ;
  ]

(* duplicate lists *)
let duplicate_list_generators = 
  [ (Duplicate_list.Prog.duplicate_list_gen, "prog") ;
  (Duplicate_list.Prog1_syn.duplicate_list_gen, "prog1_syn") ; (Duplicate_list.Prog2_syn.duplicate_list_gen, "prog2_syn") ; (Duplicate_list.Prog3_syn.duplicate_list_gen, "prog3_syn") ; 
  (Duplicate_list.Prog1_cov.duplicate_list_gen, "prog1_cov") ; (Duplicate_list.Prog2_cov.duplicate_list_gen, "prog2_cov") ; (Duplicate_list.Prog3_cov.duplicate_list_gen, "prog3_cov") ;
  (Duplicate_list.Prog1_safe.duplicate_list_gen, "prog1_safe") ; (Duplicate_list.Prog2_safe.duplicate_list_gen, "prog2_safe") ; (Duplicate_list.Prog3_safe.duplicate_list_gen, "prog3_safe") ]

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
let sorted_list_arbitraries = List.map (fun (gen, name) -> (arb_builder (size_int_wrapper (catch_err gen)), name)) sorted_list_generators

let example = arb_builder (pair_size Sized_list.Prog.sized_list_gen)
