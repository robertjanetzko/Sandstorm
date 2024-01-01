open Engine.DefaultComponents

let player_pos () =
  match PlayerInput.C.first () with
  | Some (player_id, _) ->
    (match Position.get_opt player_id with
     | Some player_pos -> player_pos
     | None -> Raylib.Vector2.zero ())
  | None -> Raylib.Vector2.zero ()
;;

let collision_layer_player = 1 lsl 1
let collision_layer_projectile = 1 lsl 2
let collision_layer_experience = 1 lsl 3
let collision_mask layers = List.fold_left ( + ) 0 layers
