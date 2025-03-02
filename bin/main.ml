
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

let precondition_frequency prop name gen_type =
  QCheck.(Test.make
  ~count:20000
  ~max_fail: 1
  ~name
    (gen_type) (fun l ->
      (try assume (prop l) with 
      Combinators.BailOut -> QCheck2.Test.fail_report "failure");
      func l))
      (* assume (prop l);
      func l)) *)

      (* fix this *)
let precondition_frequency_size gen name = precondition_frequency ((fun prop (n, l) -> QCheck.assume (prop n l); func l ) is_sized) 
  name (QCheck.pair (QCheck.int) (gen))
let precondition_frequency_sort gen name = precondition_frequency is_sorted name gen
let precondition_frequency_dup gen name = precondition_frequency is_duplicate name gen
let precondition_frequency_unique gen name = precondition_frequency is_unique name gen

(* creates tests for each generator *)
let sized_list_tests = List.map (fun (gen, name) -> precondition_frequency_size gen name) Arbitrary_builder.sized_list_arbitraries
let example = [precondition_frequency_size Arbitrary_builder.unique_list "example"]


let tests = example
let foldername = "./bin/sized_list/"


(* command line args *)
let args = Array.to_list(Sys.argv)

(* returns name of the test *)
let t_get_name (QCheck2.Test.Test c) = QCheck2.Test.get_name c

let is_required (test : QCheck2.Test.t) = List.mem (t_get_name test) args
  
let () = 
  let argc = Array.length Sys.argv in
  (* let tests = 
    if Array.mem "-t" Sys.argv then
      if argc >= 3 then
        (* filters out non-name tests *)
        List.filter is_required tests
      else 
        let () = print_endline "usage: <program> -t -o <test1> <test2> ..." in
        []
    else 
      tests
    in *)
      if Array.mem "-o" Sys.argv then
        let () =

          let _ = List.iter (fun g -> 
            QCheck_runner.set_seed 0;
            let filename = foldername ^ (t_get_name g) ^ ".result" in
            let oc = open_out filename in
            ignore (QCheck_runner.run_tests ~verbose:true ~out:oc [g]);
            close_out oc
            ) tests in ()

        in ()
      else 
        let _ = List.iter (fun g -> 
          QCheck_runner.set_seed 0;
          ignore (QCheck_runner.run_tests ~verbose:true [g]);
          ) tests in ()




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