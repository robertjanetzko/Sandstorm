open Sandstorm_raylib_components
open Components

let player_pos () =
  match Player.Tag.first () with
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
(* let q = (module Position) ^& (module Tag) ^? (module Collision.Impact)
   let () = query_eval 12 q (fun _a _b _c -> ())
   let () = query_each q (fun _id _a _b _c -> ()) *)
