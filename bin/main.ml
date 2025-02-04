
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
(* let rec is_unique = function
| [] -> true
| h::t -> if List.mem h t then false else is_unique t *)

(* let precondition_frequency_sized = precondition_frequency is_sized *)

let precondition_frequency prop name =
  QCheck.(Test.make
  ~count:20000
  ~name
   (pair (int) (list int)) (fun (n, l) ->
      assume (prop n l);
      func l))

let precondition_frequency_size = precondition_frequency is_sized "tests_R_us: is_sized"
let precondition_frequency_sort = precondition_frequency (fun _ l -> is_sorted l) "tests_R_us: is_sorted"
let precondition_frequency_dup = precondition_frequency (fun _ l -> is_duplicate l) "tests_R_us: is_duplicate"

(* let precondition_frequency_dup = precondition_frequency (fun _ l -> is_unique l) "tests_R_us: is_unique" *)

let tests = [precondition_frequency_size; precondition_frequency_sort; precondition_frequency_dup]

let () = if Array.length Sys.argv > 1 && Sys.argv.(1) = "-o" then

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