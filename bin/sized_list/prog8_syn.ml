open Combinators
let rec sized_list_gen = fun s ->
  let (xccc2) = sizecheck s in
  match xccc2 with
  | true -> []
  | false ->
      let (idx12) = bool_gen () in
      (match idx12 with
       | true ->
           let (idx2) = s in
           let (idx5ccc0) = subs idx2 in
           let (idx7ccc2) = sized_list_gen idx5ccc0 in
           let (idx1ccc0) = int_gen () in idx1ccc0 :: idx7ccc2
       | false -> [])