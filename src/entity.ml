type id_t = int

let next_id = ref 0

let create (cmps : (id_t -> unit) list) =
  let id =
    incr next_id;
    !next_id
  in
  let add_component id f = f id in
  List.iter (add_component id) cmps
;;
