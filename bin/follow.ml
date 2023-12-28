open Engine
open Engine.DefaultComponents
open Raylib

module C = struct
  type s = unit

  include (val Component.create () : Component.Sig with type t = s)
end

module S = struct
  let follow id _c pos =
    let direction = Vector2.subtract (Util.player_pos ()) pos |> Vector2.normalize in
    let velocity = Vector2.scale direction (50. *. get_frame_time ()) in
    Position.set (Vector2.add pos velocity) id
  ;;

  include (val System.create2 follow (module C) (module Position))
end
