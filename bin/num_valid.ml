open Combinators

let timeout = 300 (*  5 minutes *)
let time_out_ref = ref false

exception Timed_out

let () =
  Core.Signal.Expert.handle Core.Signal.alrm (fun (_ : Core.Signal.t) ->
      Printf.printf "Timed out";
      time_out_ref := true)

let counter = ref 0

let run_X_times (f : unit -> 'a) (num : int) : (_ * int) list =
  let map = ref [] in

  let rec loop n =
    if !time_out_ref then raise Timed_out;
    if n = num then ()
    else
      let result = f () in
      let size = result |> fst in

      if size <= 1 then counter := !counter + 1;

      let result = result |> snd in

      (match List.assoc_opt result !map with
      | Some count ->
          map := (result, count + 1) :: List.remove_assoc result !map
      | None -> map := (result, 1) :: !map);
      loop (n + 1)
  in
  let () = loop 0 in
  print_newline ();
  !map

let () = QCheck_runner.set_seed 0
let sized_list_gen = Arbitrary_builder.sized_list_arbitraries |> List.hd |> fst
let res = run_X_times sized_list_gen 20000
let num_valid = List.length res

let () =
  Printf.printf "Number of valid sized lists: %d\n" num_valid;
  if num_valid = 0 then Printf.printf "No valid sized lists found.\n"
  else (
    Printf.printf "Found %d valid sized lists.\n" num_valid;

    Printf.printf "Sample valid sized lists:\n";
    List.iter
      (fun (l, count) ->
        if count > 1 then
          Printf.printf "List: %s, Count: %d (repeated)\n"
            (String.concat ", " (List.map string_of_int l))
            count
        else ())
      res);

  if !counter > 0 then
    Printf.printf "Number of small sizes found: %d\n" !counter;

  if !time_out_ref then
    Printf.printf "The operation timed out after %d seconds.\n" timeout
  else Printf.printf "Operation completed successfully.\n"
