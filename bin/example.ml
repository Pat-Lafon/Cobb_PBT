(* Placeholder function - replace with your actual implementation *)
let func l n =
  (* TODO: Implement your function here *)
  (* Takes a list and an int, returns some value *)
  true

(* Placeholder check_post - replace with your actual postcondition *)
let check_post result =
  (* TODO: Implement your postcondition check here *)
  true

(* Original test - commented out *)
(* let bad_test =
  QCheck.(
    Test.make ~count:20000 ~name:"tests_R_us"
      (pair int (list int))
      (fun (n, l) ->
        assume (List.length l <= n);
        func l n |> check_post)) *)

(* New test using even list precondition *)
(* let bad_test =
  QCheck.(
    Test.make ~count:20000 ~name:"tests_R_us" (list int) (fun l ->
        assume (Precondition.is_even_list l);
        func l |> check_post)) *)

(* Test using specialized even list generator from Arbitrary_builder *)
let gen_func = List.hd Arbitrary_builder.even_list_arbitraries |> fst

let even_list_arb =
  QCheck.make (fun _rs ->
      let _size, l = gen_func () in
      l)

let specialized_even_test =
  QCheck.(
    Test.make ~count:20000 ~name:"tests_R_us" even_list_arb
      (fun l -> func l |> check_post))

let () =
  (* Set seed for reproducible results *)
  let seed = 42 in
  QCheck_base_runner.set_seed seed;
  let exit_code =
    QCheck_runner.run_tests ~verbose:true [ specialized_even_test ]
  in
  exit exit_code
