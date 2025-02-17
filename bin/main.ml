
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

let default_gen = Combinators.int_list_sorted

let precondition_frequency prop name gen_type =
  QCheck.(Test.make
  ~count:20000
  ~name
   (pair (int) (gen_type)) (fun (n, l) ->
      assume (prop n l);
      func l))

let precondition_frequency_size = precondition_frequency is_sized "is_sized" default_gen
let precondition_frequency_sort = precondition_frequency (fun _ l -> is_sorted l) "is_sorted" default_gen
let precondition_frequency_dup = precondition_frequency (fun _ l -> is_duplicate l) "is_duplicate" default_gen
let precondition_frequency_unique = precondition_frequency (fun _ l -> is_unique l) "is_unique" default_gen

(* list of all possible tests to run *)
let sample_tests = [precondition_frequency_size; precondition_frequency_sort; precondition_frequency_dup; precondition_frequency_unique]

(* command line args *)
let args = Array.to_list(Sys.argv)

(* returns name of the test *)
let t_get_name (QCheck2.Test.Test c) = QCheck2.Test.get_name c

(* condition for filter *)
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