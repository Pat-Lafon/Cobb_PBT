open Combinators

let timeout = 300 (*  5 minutes *)
let time_out_ref = ref false

exception Timed_out

let () =
  Core.Signal.Expert.handle Core.Signal.alrm (fun (_ : Core.Signal.t) ->
      Printf.printf "Timed out";
      time_out_ref := true)

let counter = ref 0

let run_X_times (f : unit -> 'a option) (num : int) : (_ * int) list * int =
  let map = ref [] in
  let none_count = ref 0 in
  let rec loop n =
    if !time_out_ref then raise Timed_out;
    if n >= num then ()
    else
      match f () with
      | None ->
          none_count := !none_count + 1;
          loop (n + 1)
      | Some result ->
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
  (!map, !none_count)

(* List of (label, generator) for the first generator of each kind *)
let first_gens =
  [
    ( "sized_list",
      fun () ->
        Some ((Arbitrary_builder.sized_list_arbitraries |> List.hd |> fst) ())
    );
    ( "unique_list",
      fun () ->
        Some ((Arbitrary_builder.unique_list_arbitraries |> List.hd |> fst) ())
    );
    ( "even_list",
      fun () ->
        Some ((Arbitrary_builder.even_list_arbitraries |> List.hd |> fst) ()) );
    ( "sorted_list",
      fun () ->
        match
          (Arbitrary_builder.sorted_list_arbitraries |> List.hd |> fst) ()
        with
        | Some (size, _x, l) -> Some (size, l)
        | None -> None );
    ( "duplicate_list",
      fun () ->
        let v =
          (Arbitrary_builder.duplicate_list_arbitraries |> List.hd |> fst) ()
        in
        let size, _x, l = v in
        Some (size, l) );
    ( "rbtree",
      fun () ->
        let v = (Arbitrary_builder.rbtree_arbitraries |> List.hd |> fst) () in
        let _inv, _color, height, tree = v in
        let rec tree_to_list t =
          match t with
          | Rbtleaf -> []
          | Rbtnode (_c, l, v, r) -> v :: (tree_to_list l @ tree_to_list r)
        in
        Some (height, tree_to_list tree) );
  ]

let () =
  List.iter
    (fun (label, gen) ->
      QCheck_runner.set_seed 0;
      counter := 0;
      Printf.printf "\n--- Benchmarking first %s generator ---\n" label;
      let res, none_count = run_X_times gen 20000 in
      let num_unique = List.length res in
      Printf.printf "Number of unique %s: %d\n" label num_unique;
      Printf.printf "Number of None results: %d\n" none_count;
      if num_unique = 0 then Printf.printf "No unique %s found.\n" label
      else (
        Printf.printf "Found %d unique %s.\n" num_unique label;
        Printf.printf "Sample unique %s:\n" label;
        List.iter
          (fun (l, count) ->
            if count > 1 then
              Printf.printf "Value: %s, Count: %d (repeated)\n"
                (match l with
                | l when label = "rbtree" -> "<tree>"
                | l -> String.concat ", " (List.map string_of_int l))
                count
            else ())
          res);
      if !counter > 0 then
        Printf.printf "Number of small sizes found: %d\n" !counter;
      if !time_out_ref then
        Printf.printf "The operation timed out after %d seconds.\n" timeout
      else Printf.printf "Operation completed successfully.\n")
    first_gens
