open Combinators

let rec size_bst_gen (d : int) (lo : int) (hi : int) : int tree =
  if sizecheck d then Leaf
  else if incr lo < hi then
    let (x : int) = int_range lo hi in

    freq_gen d
      ~base_case:(fun _ -> tree_gen ())
      ~recursive_case:(fun _ ->
        let (lt : int tree) = size_bst_gen (subs d) lo x in
        let (rt : int tree) = size_bst_gen (subs d) x hi in
        Node (x, lt, rt))
  else Leaf
