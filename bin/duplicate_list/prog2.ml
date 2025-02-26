let rec duplicate_list_gen (s : int) (x : int) : int list =
  if sizecheck s then [] else Err