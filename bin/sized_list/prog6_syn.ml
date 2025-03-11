open Combinators
let rec sized_list_gen = fun s ->
  let (xccc3) = sizecheck s in
  match xccc3 with
  | true -> []
  | false ->
      let (idx3) = bool_gen () in
      (match idx3 with
       | true -> []
       | false ->
           let (idx2) = s in
           let (idx6ccc0) = subs idx2 in
           let (idx8ccc2) = sized_list_gen idx6ccc0 in
           let (idx1ccc0) = int_gen () in idx1ccc0 :: idx8ccc2)