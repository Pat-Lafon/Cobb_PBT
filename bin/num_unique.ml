open Combinators

let run_X_times (f : unit -> 'a option) (num : int) :
    (_ * int) list * int * (_ * int) list =
  let map = ref [] in
  let none_count = ref 0 in
  let rec loop n =
    if n >= num then ()
    else
      match f () with
      | None ->
          none_count := !none_count + 1;
          loop (n + 1)
      | Some result ->
          let _size = result |> fst in
          let result = result |> snd in
          (match List.assoc_opt result !map with
          | Some count ->
              map := (result, count + 1) :: List.remove_assoc result !map
          | None -> map := (result, 1) :: !map);
          loop (n + 1)
  in
  let () = loop 0 in
  let duplicates = List.filter (fun (_, count) -> count > 1) !map in
  (!map, !none_count, duplicates)

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
    ( "complete_tree",
      fun () ->
        let v =
          (Arbitrary_builder.complete_tree_arbitraries |> List.hd |> fst) ()
        in
        let height, tree = v in
        let rec tree_to_list t =
          match t with
          | Leaf -> []
          | Node (v, l, r) -> v :: (tree_to_list l @ tree_to_list r)
        in
        Some (height, tree_to_list tree) );
    ( "depth_tree",
      fun () ->
        let v =
          (Arbitrary_builder.depth_tree_arbitraries |> List.hd |> fst) ()
        in
        let height, tree = v in
        let rec tree_to_list t =
          match t with
          | Leaf -> []
          | Node (v, l, r) -> v :: (tree_to_list l @ tree_to_list r)
        in
        Some (height, tree_to_list tree) );
  ]

(* Clean CSV output *)
let output_file = "bin/unique_data/unique_results.csv.results"

let print_csv_header oc =
  Printf.fprintf oc
    "Generator,Unique_Count,Total_Duplicates,Duplicate_Count,None_Count\n"

let print_csv_row oc label num_unique total_duplicates duplicate_count
    none_count =
  Printf.fprintf oc "%s,%d,%d,%d,%d\n" label num_unique total_duplicates
    duplicate_count none_count

let () =
  (* Create directory if it doesn't exist *)
  let dir = Filename.dirname output_file in
  (try Unix.mkdir dir 0o755 with Unix.Unix_error (Unix.EEXIST, _, _) -> ());

  let oc = open_out output_file in
  print_csv_header oc;
  List.iter
    (fun (label, gen) ->
      QCheck_runner.set_seed 0;
      let res, none_count, duplicates = run_X_times gen 20000 in
      let num_unique = List.length res in
      let duplicate_count = List.length duplicates in
      let total_duplicates =
        List.fold_left (fun acc (_, count) -> acc + count - 1) 0 duplicates
      in
      print_csv_row oc label num_unique total_duplicates duplicate_count
        none_count)
    first_gens;
  close_out oc;
  Printf.printf "Results written to %s\n" output_file
