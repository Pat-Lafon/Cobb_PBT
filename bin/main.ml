let test_count = 20000
let test_max_fail = 20000


let func _l = true[@@ gen]

(* preconditions for list *)
let is_sized n l = List.length l <= n

let rec is_sorted_aux = function
| h1 :: h2::t -> if h1 <= h2 then is_sorted_aux (h2 :: t) else false
| _ -> true

let is_sorted = function
  | Some l -> is_sorted_aux l
  | None -> QCheck2.Test.fail_report "bail out"

let rec is_duplicate = function
| h1::h2::t -> if h1 = h2 then is_duplicate (h2::t) else false
| _ -> true

let is_unique l =
  let len = List.length l in
  let set = Hashtbl.create len in
  let () = List.iter (fun x -> Hashtbl.replace set x ()) l in
  len = Hashtbl.length set

(* units for filter functions *)
let has_same_size l s = List.length = s
let rec has_duplicate_int_x l x = match l with
  | [] -> true
  | h :: t -> h = x && has_duplicate_int_x t x

(* do the filter functions need to check for size? *)
(* safety filter functions for duplicate *)
let is_duplicate_prog123_safe l s x =
  has_same_size l s && has_duplicate_int_x l x
(* the safety repairs are just the correct repairs *)

(* list of not safe filter functions for duplicate *)
let is_not_safe_duplicate  = [
  ("prop1_safe", fun l s x -> not (is_duplicate_prog123_safe l s x)) ;
  ("prop2_safe", fun l s x -> not (is_duplicate_prog123_safe l s x)) ;
  ("prop3_safe", fun l s x -> not (is_duplicate_prog123_safe l s x)) ;
]

(* safety filter functions for unique *)
let is_unique_prog1_safe l s =
  has_same_size l s && is_unique l
let is_unique_prog2_safe l s =
  has_same_size l s && is_unique l
let is_unique_prog3_safe l s =
  has_same_size l s && is_unique l

(* safety filter functions for sized *)
let is_sized_prog1_safe l s = is_sized s l
let is_sized_prog2_safe l s = is_sized s l
let is_sized_prog3_safe l s = l = []
let is_sized_prog4_safe l s = is_sized s l
let is_sized_prog5_safe l s = l = []
let is_sized_prog6_safe l s = l = []
let is_sized_prog7_safe l s = l = []
let is_sized_prog8_safe l s = l = []
let is_sized_prog9_safe l s = l = []



(* safety filter functions for sorted *)
let is_sorted_prog1_safe l s x =
  has_same_size l s && has_duplicate_int_x l x
let is_sorted_prog2_safe l s x =
  has_same_size l s && has_duplicate_int_x l x
let is_sorted_prog3_safe l s x =
  has_same_size l s && has_duplicate_int_x l x


(* QCheck.make *)
let precondition_frequency prop (gen_type, name) =
  QCheck.(Test.make
  ~count:test_count
  ~max_fail:test_max_fail
  ~name
    (gen_type) (fun l ->
      assume (prop l);
      func l))

let precondition_frequency_pair prop (gen_type, name) =
  QCheck.(Test.make
  ~count:test_count
  ~max_fail:test_max_fail
  ~name
    (gen_type) (fun (n, l) ->
      assume (prop n l);
      func l))


let create_test_list prop gens =
  List.map (precondition_frequency prop) gens
let create_test_pair_list prop gens = List.map (precondition_frequency_pair prop) gens

(* creates list of tests for runniing against filter functions *)
let create_test_prop_list props (gen, _ ) = List.map (fun (prop, name) -> precondition_frequency prop (gen, name)) props


(* list of only the ref generators for each *)
let ref_generator_assoc_list = [
  ("duplicate_list", List.nth Arbitrary_builder.duplicate_list_arbitraries 0)
]

(* algebraic data type for the generator arbitraries,
  helps with making a cleaner association list *)
type generator_t =
  | Single of (int list QCheck.arbitrary * string) list
  | Pair of ((int * int list) QCheck.arbitrary * string) list
  | Option of (int list option QCheck.arbitrary * string) list

(* association list for the generators and their names *)
let generator_assoc_list = [
  ("duplicate_list", Single Arbitrary_builder.duplicate_list_arbitraries) ;
  ("sized_list", Pair Arbitrary_builder.sized_list_arbitraries) ;
  ("sorted_list", Option Arbitrary_builder.sorted_list_arbitraries) ;
  ("unique_list", Single Arbitrary_builder.unique_list_arbitraries) ;
  ]

(* I don't know if there's something similar for functions?
  I found something about GADT's but I would need to investigate more *)

(* type property_t =
  | Single : ('a list -> bool) -> property_t
  | Pair : (int -> 'a list -> bool) -> property_t
  | Option : ('a list option -> bool) -> property_t *)

let single_prop_assoc_list = [
  ("is_duplicate", is_duplicate) ;
  ("is_unique", is_unique) ;
  ]
let pair_prop_assoc_list = [
  ("is_sized", is_sized);
  ]
let option_prop_assoc_list = [
  ("is_sorted", is_sorted) ;
]


(* command line args *)
let args = Array.to_list(Sys.argv)

(* returns name of the test *)
let t_get_name (QCheck2.Test.Test c) = QCheck2.Test.get_name c

let () =
  let argc = Array.length Sys.argv in

    try
      (* if Array.get Sys.argv 1 = "-fs" then
        let tests = create_test_prop_list is_not_safe_duplicate (List.assoc gen_name ref_generator_assoc_list)


      else *)

      let prop_name = Array.get Sys.argv 1 in
      let gen_name = Array.get Sys.argv 2 in

        (* creates a list of tests with each variation of the generator *)
      let tests =
        match List.assoc gen_name generator_assoc_list with
          | Single g -> create_test_list (List.assoc prop_name single_prop_assoc_list) g
          | Pair g -> create_test_pair_list (List.assoc prop_name pair_prop_assoc_list) g
          | Option g -> create_test_list (List.assoc prop_name option_prop_assoc_list) g
      in

      (* folder to output to *)
      let foldername = "./bin/" ^ gen_name ^ "/" in

      (* runs test for each variation of the generator with seed 0*)
      List.iter (fun g ->
        QCheck_runner.set_seed 0;
        let filename = foldername ^ (t_get_name g) ^ ".result" in
        let oc = open_out filename in
        ignore (QCheck_runner.run_tests ~verbose:true ~out:oc [g]);
        close_out oc
        ) tests

    with
    (* prints usage *)
    | Invalid_argument s->  print_endline "Usage: dune exec Cobb_PBT -- property_name generator_name"
    (* dune exec Cobb_PBT -- -fs property_name *)
