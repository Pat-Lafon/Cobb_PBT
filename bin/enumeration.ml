open Combinators

let run_X_times (f: unit -> 'a) (check_opt : ('a -> bool) option) (count : 'a -> int) (num : int) : float =
(
  let sum = ref 0 in
  let start_time = Unix.gettimeofday () in

  let rec loop n =
    if n = num then ()
    else
      let result = f () in
      match check_opt with
      | Some check ->
        if check result then
          let instance_count = count result in
          sum := !sum + instance_count;
          loop (n + 1)
        else
          loop n
      | None ->
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

let f : float = run_X_times (fun () : int -> int_gen ()) (Some (fun (_: int) -> true)) (fun (x: int) -> x) 10000
let () = Printf.printf "Time: %f\n" f
let f : float = run_X_times (fun () : int -> int_gen ()) (Some (fun (_: int) -> true)) (fun (x: int) -> x) 100000
let () = Printf.printf "Time: %f\n" f

open Rbtree

let rbtree_gen h =
  let color = true in
  let inv = if color then
    h + h
  else h + h + 1 in
  Prog.rbtree_gen inv color h

let black_heights = [1; 2; 3; 4; 5; 6; 7;]
let number_of_trees = [1000; 10000; 100000]

let rbtree_prog_time : float = run_X_times (fun () -> rbtree_gen 5) None (count_rbtree_nodes)  100000
let () = Printf.printf "Time: %f\n" rbtree_prog_time

let rbtree_prog_time : float = run_X_times (fun () -> (rbtree_gen 5, 5)) (Some (fun (t, h) -> rbtree_invariant t h)) (fun x -> count_rbtree_nodes (fst x))  100000
let () = Printf.printf "Time: %f\n" rbtree_prog_time