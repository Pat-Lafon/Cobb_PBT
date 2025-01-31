(* This is a dummy user functon that always works *)
let func _l = true[@@ gen]

(* let is_sized n l = List.length l <= n *)

let rec is_sorted = function
| h1 :: h2::t -> if h1 <= h2 then is_sorted (h2 :: t) else false
| _ -> true

(* let rec is_duplicate = function
| h1::h2::t -> if h1 = h2 then is_duplicate (h2::t) else false
| _ -> false *)

(* this is quite slow *)
(* also could be broken? Every case passes *)
(* let rec is_unique = function
| [] -> true
| h::t -> if List.mem h t then false else is_unique t *)


(* let precondition_frequency =
  QCheck.(Test.make
  ~count:20000
  ~name:"tests_R_us"
   (pair (int) (list int)) (fun (n, l) ->
      assume (is_sized n l);
      func l)) *)

let precondition_frequency =
  QCheck.(Test.make
  ~count:20000
  ~name:"tests_R_us: is_sorted"
   (pair (int)  (list int)) (fun (_n, l) ->
      assume (is_sorted l);
      func l))

(* let precondition_frequency =
  QCheck.(Test.make
  ~count:20000
  ~name:"tests_R_us: is_duplicate"
   (pair (int)  (list int)) (fun (_n, l) ->
      assume (is_duplicate l);
      func l)) *)

(* let precondition_frequency =
  QCheck.(Test.make
  ~count:20000
  ~name:"tests_R_us: is_uniqe"
   (pair (int)  (list int)) (fun (_n, l) ->
      assume (is_unique l);
      func l)) *)

      (* let () =
        let oc = open_out file in
        Printf.fprintf oc "%s\n" "hi";
        close_out oc; *)
let file = "results.txt"

let argv = [| "-v"; "--verbose"; "--seed"; "0" |]
let () =
  let oc = open_out file in
  let fmt = Format.formatter_of_out_channel oc in
  Format.fprintf fmt "Running QCheck Tests with options: %a\n\n" 
    (Format.pp_print_list Format.pp_print_string) (Array.to_list argv);

  (* Run the tests using QCheck_runner.run_tests *)
  let _ = QCheck_runner.run_tests ~verbose:true ~out:oc [precondition_frequency]  in

  (* Close the file after capturing results *)
  close_out oc;


(* let () = QCheck_runner.run_tests_main ~argv:[|"-v"; "--verbose"; "--seed"; "0"|] [precondition_frequency] *)