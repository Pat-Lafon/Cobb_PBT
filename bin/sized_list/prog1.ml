let rec sized_list_gen (s : int) : int list =
  if sizecheck s then Err
  else if bool_gen () then []
  else int_gen () :: sized_list_gen (subs s)
