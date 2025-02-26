let rec sorted_list_gen (s : int) (x : int) : int list =
  if sizecheck s then []
  else
    let (y : int) = int_gen () in
    if x <= y then Exn else Exn