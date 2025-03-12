open Precondition

let test_count = 20000
let test_max_fail = 20000

(* do the filter functions need to check for size? *)
(* safety filter functions for duplicate *)
let is_duplicate_prog123_safe (s, x, l) =
  has_same_size (s, l) && has_duplicate_int_x l x
(* the safety repairs are just the correct repairs *)

let neg f x = not (f x)
let check_some f x = Option.fold ~none:true ~some:f x

(* list of not safe filter functions for duplicate *)
let is_not_safe_duplicate =
  [
    ("prop1_safe", neg is_duplicate_prog123_safe);
    ("prop2_safe", neg is_duplicate_prog123_safe);
    ("prop3_safe", neg is_duplicate_prog123_safe);
  ]

let is_unique_safe (s, l) = has_same_size (s, l) && is_unique l

(* safety filter functions for unique *)
let is_not_safe_unique =
  [
    ("prop1_safe", neg is_unique_safe);
    ("prop2_safe", neg is_unique_safe);
    ("prop3_safe", neg is_unique_safe);
  ]

let is_empty_wrapper (s, l) = is_empty l

let is_not_safe_sized =
  [
    ("prop1_safe", neg is_sized);
    ("prop2_safe", neg is_sized);
    ("prop3_safe", neg is_empty_wrapper);
    ("prop4_safe", neg is_sized);
    ("prop5_safe", neg is_empty_wrapper);
    ("prop6_safe", neg is_empty_wrapper);
    ("prop7_safe", neg is_empty_wrapper);
    ("prop8_safe", neg is_empty_wrapper);
    ("prop9_safe", neg is_empty_wrapper);
  ]

(* safety filter functions for sorted *)
let is_sorted_prog1_safe (s, x, l) =
  has_same_size (s, l)
  && is_sorted l
  && if_head_map_f_else_true (fun h -> h >= x) l

let is_sorted_prog23_safe (s, x, l) =
  has_same_size (s, l) && has_duplicate_int_x l x

let is_not_safe_sorted =
  [
    ("prop1_safe", neg (check_some is_sorted_prog1_safe));
    ("prop2_safe", neg (check_some is_sorted_prog23_safe));
    ("prop3_safe", neg (check_some is_sorted_prog23_safe));
  ]

(* QCheck.make *)
let precondition_frequency prop (gen_type, name) =
  QCheck.(
    Test.make ~count:test_count ~max_fail:test_max_fail ~name
      (QCheck.make (fun _ -> gen_type ()))
      (fun l ->
        assume (prop l);
        true))

(* let precondition_frequency_pair prop (gen_type, name) =
  QCheck.(
    Test.make ~count:test_count ~max_fail:test_max_fail ~name gen_type
      (fun (n, l) ->
        assume (prop n l);
        true))
 *)
let create_test_list prop gens = List.map (precondition_frequency prop) gens

(* creates list of tests for runniing against filter functions *)
let create_test_prop_list props (gen, _) =
  List.map (fun (prop, name) -> precondition_frequency prop (gen, name)) props

(* list of only the ref generators for each *)
let ref_generator_assoc_list =
  [
    ("duplicate_list", List.nth Arbitrary_builder.duplicate_list_arbitraries 0);
  ]

let eval_2_sized_list =
  ( "sized_list",
    List.map
      (precondition_frequency Precondition.is_sized)
      Arbitrary_builder.sized_list_arbitraries )

let eval_2_sorted_list =
  ( "sorted_list",
    List.map
      (precondition_frequency
         (Option.fold ~none:false ~some:(fun (size, x, l) ->
              Precondition.is_sorted l
              && Precondition.has_same_size (size, l)
              && Precondition.if_head_map_f_else_true (fun h -> h >= x) l)))
      Arbitrary_builder.sorted_list_arbitraries )

let eval_2_duplicate_list =
  ( "duplicate_list",
    List.map
      (precondition_frequency (fun (size, x, l) ->
           Precondition.is_duplicate l
           && Precondition.has_same_size (size, l)
           && Precondition.if_head_map_f_else_true (fun h -> h = x) l))
      Arbitrary_builder.duplicate_list_arbitraries )

let eval_2_unique_list =
  ( "unique_list",
    List.map
      (precondition_frequency (fun (size, l) ->
           Precondition.is_unique l && Precondition.has_same_size (size, l)))
      Arbitrary_builder.unique_list_arbitraries )

let eval_2_complete_tree =
  ( "complete_tree",
    List.map
      (precondition_frequency (fun (size, tree) ->
           Precondition.complete tree && Precondition.depth tree = size))
      Arbitrary_builder.complete_tree_arbitraries )

let eval_2_depth_tree =
  ( "depth_tree",
    List.map
      (precondition_frequency (fun (size, tree) ->
           Precondition.depth tree <= size))
      Arbitrary_builder.depth_tree_arbitraries )

let eval_2_depth_bst_tree =
  ( "depth_bst_tree",
    List.map
      (precondition_frequency (fun (size, lo, high, tree) ->
           Precondition.depth tree <= size
           && Precondition.bst tree
           && Precondition.lower_bound tree lo
           && Precondition.upper_bound tree high))
      Arbitrary_builder.depth_bst_tree_arbitraries )

let eval_2_rbtree =
  ( "rbtree",
    List.map
      (precondition_frequency (fun (inv, color, height, tree) ->
           assert (if color then 2 * height = inv else (2 * height) + 1 = inv);
           (if color then not (Precondition.rb_root_color tree true)
            else if height == 0 then not (Precondition.rb_root_color tree false)
            else true)
           && Precondition.rbtree_invariant tree height))
      Arbitrary_builder.rbtree_arbitraries )

let eval_3_sized_list =
  ( "sized_list",
    List.map
      (fun (name, f) ->
        precondition_frequency f
          (List.hd Arbitrary_builder.sized_list_arbitraries |> fst, name))
      is_not_safe_sized )

let eval_3_sorted_list =
  ( "sorted_list",
    List.map
      (fun (name, f) ->
        precondition_frequency f
          (List.hd Arbitrary_builder.sorted_list_arbitraries |> fst, name))
      is_not_safe_sorted )

let eval_3_unique_list =
  ( "unique_list",
    List.map
      (fun (name, f) ->
        precondition_frequency f
          (List.hd Arbitrary_builder.unique_list_arbitraries |> fst, name))
      is_not_safe_unique )

let eval_3_duplicate_list =
  ( "duplicate_list",
    List.map
      (fun (name, f) ->
        precondition_frequency f
          (List.hd Arbitrary_builder.duplicate_list_arbitraries |> fst, name))
      is_not_safe_duplicate )

(* command line args *)
let args = Array.to_list Sys.argv

(* returns name of the test *)
let t_get_name (QCheck2.Test.Test c) = QCheck2.Test.get_name c

let eval2 =
  [
    eval_2_sized_list;
    eval_2_sorted_list;
    eval_2_unique_list;
    eval_2_duplicate_list;
    eval_2_complete_tree;
    eval_2_depth_tree;
    eval_2_depth_bst_tree;
    eval_2_rbtree;
  ]

let eval3 =
  [
    eval_3_sized_list;
    eval_3_sorted_list;
    eval_3_duplicate_list;
    eval_3_unique_list;
  ]

let () =
  let argc = Array.length Sys.argv in

  try
    (* if Array.get Sys.argv 1 = "-fs" then
        let tests = create_test_prop_list is_not_safe_duplicate (List.assoc gen_name ref_generator_assoc_list)


      else *)
    let eval_name = Array.get Sys.argv 1 in
    let gen_name =
      try Array.get Sys.argv 2 with Invalid_argument _ -> "any"
    in

    let eval, dir =
      if eval_name = "eval2" then (eval2, "./bin/")
        (* TODO: redirect to different folder... probably make a data folder for easy cleanup *)
      else if eval_name = "eval3" then (eval3, "./bin/completeness_data/")
      else failwith "Invalid arg 1, expected eval2|eval3"
    in

    let tests =
      if gen_name = "any" then eval
      else [ (gen_name, List.assoc gen_name eval) ]
    in

    List.iter
      (fun (gen_name, tests) ->
        (* folder to output to *)
        let foldername = dir ^ gen_name ^ "/" in
        if not (Sys.file_exists foldername) then
          FileUtil.mkdir ~parent:true foldername;
        print_endline ("Running tests for " ^ gen_name ^ "...");
        QCheck_runner.set_seed 0;
        List.iter
          (fun g ->
            (* runs test for each variation of the generator with seed 0*)
            let filename = foldername ^ t_get_name g ^ ".result" in
            print_endline ("> Running test for " ^ t_get_name g ^ "...");
            let oc = open_out filename in
            ignore (QCheck_runner.run_tests ~verbose:true ~out:oc [ g ]);
            close_out oc)
          tests)
      tests
  with
  (* prints usage *)
  | Invalid_argument s ->
    print_endline "Usage: dune exec Cobb_PBT -- eval_name ?generator_name"
(* dune exec Cobb_PBT -- -fs property_name *)
