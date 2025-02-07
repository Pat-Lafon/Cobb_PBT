
let file = "results.txt"

let func _l = true[@@ gen]

let is_sized n l = List.length l <= n

let rec is_sorted = function
| h1 :: h2::t -> if h1 <= h2 then is_sorted (h2 :: t) else false
| _ -> true

let rec is_duplicate = function
| h1::h2::t -> if h1 = h2 then is_duplicate (h2::t) else false
| _ -> true

(* this is quite slow *)
let rec is_unique = function
| [] -> true
| h::t -> if List.mem h t then false else is_unique t

let precondition_frequency prop name =
  QCheck.(Test.make
  ~count:11111
  ~name
   (pair (int) (list int)) (fun (n, l) ->
      assume (prop n l);
      func l))

let precondition_frequency_size = precondition_frequency is_sized "tests_R_us: is_sized"
let precondition_frequency_sort = precondition_frequency (fun _ l -> is_sorted l) "tests_R_us: is_sorted"
let precondition_frequency_dup = precondition_frequency (fun _ l -> is_duplicate l) "tests_R_us: is_duplicate"
let precondition_frequency_unique = precondition_frequency (fun _ l -> is_unique l) "tests_R_us: is_unique"


let rec add_tests (tests : QCheck.Test.t list) = function
| [] -> tests
| "is_sized" :: t -> add_tests (precondition_frequency_size :: tests) t
| "is_sorted" :: t -> add_tests (precondition_frequency_sort :: tests) t
| "is_duplicate" :: t -> add_tests (precondition_frequency_dup :: tests) t
| "is_unique" :: t-> add_tests (precondition_frequency_unique :: tests) t
| _ :: t -> add_tests tests t

let () = 
  let argc = Array.length Sys.argv in
  let (tests : QCheck2.Test.t list) = 
    if Array.mem "-t" Sys.argv then
      if argc > 2 then
        let test_names = Array.to_list (Array.sub Sys.argv 1 (argc - 1)) in
        add_tests [] test_names
      else 
        let () = print_endline "usage: <program> -t -o <test1> <test2> ..." in
        []
    else 
      [precondition_frequency_size; precondition_frequency_sort; precondition_frequency_dup]
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