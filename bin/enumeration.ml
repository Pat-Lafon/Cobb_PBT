open Combinators

let run_X_times (f: unit -> 'a) (_check : 'a -> bool) (count : 'a -> int) (num : int) : float =
(
  let sum = ref 0 in
  let start_time = Unix.gettimeofday () in

  let rec loop n =
    if n = num then ()
    else
      let result = f () in
      (* if check result then
        loop (n + 1)
      else *)
      let instance_count = count result in
      sum := !sum + instance_count;
      loop (n + 1)
  in
  let () = loop 0 in
  print_int !sum;
  print_newline ();
  let end_time :float = Unix.gettimeofday () in
  end_time -. start_time)

let () = QCheck_runner.set_seed 42

let f : float = run_X_times (fun () : int -> int_gen ()) (fun (_: int) -> true) (fun (x: int) -> x) 10000
let () = Printf.printf "Time: %f\n" f
let f : float = run_X_times (fun () : int -> int_gen ()) (fun (_: int) -> true) (fun (x: int) -> x) 100000
let () = Printf.printf "Time: %f\n" f
