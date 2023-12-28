open Engine.DefaultComponents

let player_pos () =
  match PlayerInput.C.first () with
  | Some (player_id, _) ->
    (match Position.get_opt player_id with
     | Some player_pos -> player_pos
     | None -> raise Not_found)
  | None -> raise Not_found
;;
