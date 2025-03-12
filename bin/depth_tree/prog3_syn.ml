open Combinators

let rec depth_tree_gen = fun s ->
  let (xccc3) = sizecheck s in
  match xccc3 with
  | true -> Leaf
  | false ->
      let (idx3) = bool_gen () in
      (match idx3 with
       | true -> Leaf
       | false ->
           let (idx2) = s in
           let (idx6ccc0) = subs idx2 in
           let (idx8ccc8) = depth_tree_gen idx6ccc0 in
           let (idx8ccc7) = depth_tree_gen idx6ccc0 in
           let (idx1ccc0) = int_gen () in Node (idx1ccc0, idx8ccc7, idx8ccc8))