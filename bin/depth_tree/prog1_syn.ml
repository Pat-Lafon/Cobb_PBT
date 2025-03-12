open Combinators

let rec depth_tree_gen = fun s ->
  let (xccc4) = sizecheck s in
  match xccc4 with
  | true -> Leaf
  | false ->
      let (xccc5) = bool_gen () in
      (match xccc5 with
       | true -> Leaf
       | false ->
           let (ss) = subs s in
           let (lt) = depth_tree_gen ss in
           let (rt) = depth_tree_gen ss in
           let (n) = int_gen () in Node (n, lt, rt))