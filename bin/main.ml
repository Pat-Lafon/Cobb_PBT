let func _l = true[@@ gen]

let sized_list n l = List.length l <= n

(* let is_sorted l = failwith "TODO" *)

(* let is_duplicate l = failwith "TODO" *)

(* let is_unique l = failwith "TODO" *)

let bad_test =
  QCheck.(Test.make
  ~count:20000
  ~name:"tests_R_us"
   (pair (int)  (list int)) (fun (n, l) ->
      assume (sized_list n l);
      func l))

let () = QCheck_runner.run_tests_main ~argv:[|"-v"; "--verbose"; "--seed"; "0"|] [bad_test]

(* let bad_test =
  QCheck.(Test.make
  ~count:20000
  ~name:"tests_R_us"
   (pair (int)  (list int)) (fun (_n, l) ->
      assume (is_sorted l);
      func l))

let () = QCheck_runner.run_tests_main ~argv:[|"-v"; "--verbose"; "--seed"; "0"|] [bad_test]
 *)

(* let bad_assume_warn =
  QCheck.Test.make ~count:2_000
    ~name:"WARN_unlikely_precond"
    QCheck.int
    (fun x ->
       QCheck.assume (x mod 100 = 1);
       true)

let () = QCheck_runner.run_tests_main [bad_assume_warn] *)