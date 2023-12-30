open Engine
open Engine.DefaultComponents
open Raylib

module C = struct
  type s = unit

  include (val Component.create () : Component.Sig with type t = s)
end

let input_direction () =
  let open Raylib in
  let x = if is_key_down Key.A then -1. else if is_key_down Key.D then 1. else 0. in
  let y = if is_key_down Key.W then -1. else if is_key_down Key.S then 1. else 0. in
  Vector2.create x y |> Vector2.normalize
;;

let system =
  Engine.System.create_q
    (query (module Position) >& (module C))
    (fun id pos ->
      let dir = input_direction () in
      let vel = Vector2.scale dir (150. *. get_frame_time ()) in
      let new_pos = Vector2.add pos vel in
      Position.set new_pos id)
;;
