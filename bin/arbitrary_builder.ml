open Combinators
(* open Unique_list *)

(* higher order programming *)
(* make still expects random state as parameter, "_" gets rid of it *)
let arb_builder f = QCheck.make (fun _ -> f ())

(* my generators *)
let int_list = arb_builder int_list_gen
let int_list_size = arb_builder int_list_variable_size_gen
let int_list_sorted = arb_builder int_list_sorted_gen
let int_list_dup = arb_builder int_list_dup_gen
let int_list_unique = arb_builder int_list_unique_gen


(* Cobb synthesized generators *)

let size_wrapper f () =
  let x = nat_gen () in (* nat_gen instead of int_gen because size will be too large - causing stack overflow *)
  f x

let size_int_wrapper f () =
  let x1 = nat_gen () in
  let x2 = int_gen () in
  f x1 x2

(* sized lists *)
let sized_list = arb_builder (size_wrapper Sized_list.Prog.sized_list_gen)
(* synthesized *)
let sized_list_prog1_syn = arb_builder (size_wrapper Sized_list.Prog1_syn_edit.sized_list_gen)
let sized_list_prog2_syn = arb_builder (size_wrapper Sized_list.Prog2_syn_edit.sized_list_gen)
(* coverage-only *)
let sized_list_prog1_cov = arb_builder (size_wrapper Sized_list.Prog1_cov.sized_list_gen)
let sized_list_prog2_cov = arb_builder (size_wrapper Sized_list.Prog2_cov.sized_list_gen)
let sized_list_prog3_cov = arb_builder (size_wrapper Sized_list.Prog2_cov.sized_list_gen)
(* safe-only *)
let sized_list_prog1_safe = arb_builder (size_wrapper Sized_list.Prog1_safe.sized_list_gen)
let sized_list_prog2_safe = arb_builder (size_wrapper Sized_list.Prog2_safe.sized_list_gen)
let sized_list_prog3_safe = arb_builder (size_wrapper Sized_list.Prog3_safe.sized_list_gen)




(* duplicate lists *)
let duplicate_list = arb_builder (size_int_wrapper Duplicate_list.Prog.duplicate_list_gen)
(* synthesized *)
let duplicate_list_prog1_syn = arb_builder (size_int_wrapper Duplicate_list.Prog1_syn_edit.duplicate_list_gen)
let duplicate_list_prog2_syn = arb_builder (size_int_wrapper Duplicate_list.Prog2_syn_edit.duplicate_list_gen)
(* coverage-only *)
let duplicate_list_prog1_cov = arb_builder (size_int_wrapper Duplicate_list.Prog1_cov.duplicate_list_gen)
let duplicate_list_prog2_cov = arb_builder (size_wrapper Duplicate_list.Prog2_cov.duplicate_list_gen)
(* safe-only *)
let duplicate_list_prog1_safe = arb_builder (size_int_wrapper Duplicate_list.Prog1_safe.duplicate_list_gen)
let duplicate_list_prog2_safe = arb_builder (size_int_wrapper Duplicate_list.Prog1_safe.duplicate_list_gen)



(* Err in unique_list_gen *)
(* let unique_list = arb_builder (size_wrapper Unique_list.unique_list_gen) *)

(* maybe it should be a wrapper with nat and nat instead of nat and int? *)
(* let sorted_list = arb_builder (size_int_wrapper Duplicate_list_prog.sorted_list_gen) *)
  
