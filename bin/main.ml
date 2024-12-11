(* This is a dummy user functon that always works *)
let func _l = true[@@ gen]

let is_sized n l = List.length l <= n

(* let is_sorted l = failwith "TODO" *)

(* let is_duplicate l = failwith "TODO" *)

(* let is_unique l = failwith "TODO" *)

let precondition_frequency =
  QCheck.(Test.make
  ~count:20000
  ~name:"tests_R_us"
   (pair (int) (list int)) (fun (n, l) ->
      assume (is_sized n l);
      func l))

let () = QCheck_runner.run_tests_main ~argv:[|"-v"; "--verbose"; "--seed"; "0"|] [precondition_frequency]

(* let precondition_frequency =
  QCheck.(Test.make
  ~count:20000
  ~name:"tests_R_us"
   (pair (int)  (list int)) (fun (_n, l) ->
      assume (is_sorted l);
      func l))

let () = QCheck_runner.run_tests_main ~argv:[|"-v"; "--verbose"; "--seed"; "0"|] [precondition_frequency]
 *)