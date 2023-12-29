open Engine
open Engine.DefaultComponents
open Raylib

module C = struct
  type s = unit

  include (val Component.create () : Component.Sig with type t = s)
end

let system =
  System.create2r
    (module C)
    (module Position)
    (fun id _c pos ->
      let direction = Vector2.subtract (Util.player_pos ()) pos |> Vector2.normalize in
      let velocity = Vector2.scale direction (50. *. get_frame_time ()) in
      Position.set (Vector2.add pos velocity) id)
;;
