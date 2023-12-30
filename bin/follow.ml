open Engine
open Engine.DefaultComponents
open Raylib

module C = struct
  type s = unit

  include (val Component.create () : Component.Sig with type t = s)
end

let would_collide id new_pos =
  let s = Component.(query (module Collision.Shape) >? (module Position)) in
  Seq.exists (fun id2 -> Collision.overlap ~new_p1:(Some new_pos) id id2) s
;;

let system =
  System.create_q
    (query (module Position) >& (module C))
    (fun id pos ->
      let direction = Vector2.subtract (Util.player_pos ()) pos |> Vector2.normalize in
      let velocity = Vector2.scale direction (50. *. get_frame_time ()) in
      let new_pos = Vector2.add pos velocity in
      (* if not (would_collide id new_pos) then *)
      Position.set new_pos id)
;;
