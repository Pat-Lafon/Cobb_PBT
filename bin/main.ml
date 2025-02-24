
let file = "results.txt"
 
let func _l = true[@@ gen]

let is_sized n l = List.length l <= n

let rec is_sorted = function
| h1 :: h2::t -> if h1 <= h2 then is_sorted (h2 :: t) else false
| _ -> true

let rec is_duplicate = function
| h1::h2::t -> if h1 = h2 then is_duplicate (h2::t) else false
| _ -> true

let is_unique l = 
  let len = List.length l in
  let set = Hashtbl.create len in
  let () = List.iter (fun x -> Hashtbl.replace set x ()) l in 
  len = Hashtbl.length set

let default_gen = Combinators.int_list
let precondition_frequency prop name gen_type =
  QCheck.(Test.make
  ~count:20000
  ~name
    (pair (int) (gen_type)) (fun (n, l) ->
      assume (prop n l);
      func l))

(* let assume_prop prop l = QCheck.assume (prop l); func l *)

let precondition_frequency_size = precondition_frequency is_sized "is_sized" default_gen
let precondition_frequency_sort = precondition_frequency (fun _ l -> is_sorted l) "is_sorted" default_gen
let precondition_frequency_dup = precondition_frequency (fun _ l -> is_duplicate l) "is_duplicate" default_gen
let precondition_frequency_unique = precondition_frequency (fun _ l -> is_unique l) "is_unique" default_gen

(* should QCheck.int be replaced with our own gen that has st abstracted away? *)
(* there are also considerations with running the precondition for size, and how it also needs to accesss the size *)
(* let precondition_frequency_size = precondition_frequency ((fun prop (n, l) -> QCheck.assume (prop n l); func l ) is_sized) 
  "is_sized" (QCheck.pair (QCheck.int) (default_gen))
(* let precondition_frequency_size = precondition_frequency (assume_prop_pair is_sized) "is_sized" (QCheck.pair (QCheck.int) (Combinators.int_list_size)) *)
let precondition_frequency_sort = precondition_frequency (assume_prop is_sorted) "is_sorted" default_gen
let precondition_frequency_dup = precondition_frequency (assume_prop is_duplicate) "is_duplicate" default_gen
let precondition_frequency_unique = precondition_frequency (assume_prop is_unique) "is_unique" default_gen *)


(* list of all possible tests to run *)
let sample_tests = [precondition_frequency_size; precondition_frequency_sort; precondition_frequency_dup; precondition_frequency_unique]


(* command line args *)
let args = Array.to_list(Sys.argv)

(* returns name of the test *)
let t_get_name (QCheck2.Test.Test c) = QCheck2.Test.get_name c

let is_required (test : QCheck2.Test.t) = List.mem (t_get_name test) args
  
let () = 
  let argc = Array.length Sys.argv in
  let (tests) = 
    if Array.mem "-t" Sys.argv then
      if argc >= 3 then
        (* filters out non-name tests *)
        List.filter is_required sample_tests
      else 
        let () = print_endline "usage: <program> -t -o <test1> <test2> ..." in
        []
    else 
      sample_tests
    in

    if Array.mem "-o" Sys.argv then
      let argv = [| "-v"; "--verbose"; "--seed"; "0" |] in 
      let () =
        let oc = open_out file in
        let fmt = Format.formatter_of_out_channel oc in
        Format.fprintf fmt "Running QCheck Tests with options: %a\n\n" 
          (Format.pp_print_list Format.pp_print_string) (Array.to_list argv);

        (* Run the tests using QCheck_runner.run_tests *)
        let _ = QCheck_runner.run_tests ~verbose:true ~out:oc tests in

        (* Close the file after capturing results *)
        close_out oc
      in ()

    else 
      let () = QCheck_runner.run_tests_main ~argv:[|"-v"; "--verbose"; "--seed"; "0"|] tests in () 

(* tried using Arg.parse for better cli, 
  however, Arg.parse is probably interfering with QCheck_runner parameters *)
      
(*
(* returns name of the test *)
let t_get_name (QCheck2.Test.Test c) = QCheck2.Test.get_name c

let usage_msg = "dune exec Cobb_PBT [-o] [-g] <generator> [-t] <test1> [<test2>] ... "

let output_to_file = ref false
let test_names = ref []
(* let generator = ref "" *)

let anon_fun testname = test_names := testname :: !test_names

let speclist =
  [
    ("-o", Arg.Set output_to_file, "Output test results to txt file");
    (* ("-g", Arg.Set_string generator, "Set generator type"); *)
    ("-t", Arg.String anon_fun, "Set tests")
  ]

let () = 
  Arg.parse speclist anon_fun usage_msg;
  (* Printf.printf "Flag -o: %b\n" !output_to_file;
  Printf.printf "Flag -g: %s\n" !generator;
  Printf.printf "Extra arguments: [%s]\n" (String.concat ", " !test_names); *)

  let tests = 
    if List.is_empty !test_names then
      sample_tests
    else
    (* condition for filter *)
    let is_required (test : QCheck2.Test.t) = List.mem (t_get_name test) !test_names in
    List.filter is_required sample_tests 
  in 
  if !output_to_file then
    let oc = open_out file in
      let fmt = Format.formatter_of_out_channel oc in
      Format.fprintf fmt "Running QCheck Tests with options: %a\n\n" 
        (Format.pp_print_list Format.pp_print_string) (!test_names);

      (* Run the tests using QCheck_runner.run_tests *)
      let _ = QCheck_runner.run_tests ~verbose:true ~out:oc tests in
      close_out oc
  else begin
    let st = Random.State.make [|0|] in
    let _ = QCheck_runner.run_tests ~verbose:true ~rand:st tests in ()
    (* QCheck_runner.run_tests_main ~argv:[|"-v"; "--verbose"; "--seed"; "0"|] tests; *)
  end
*)