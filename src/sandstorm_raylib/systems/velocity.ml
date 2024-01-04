open Sandstorm
open Sandstorm_raylib_components
open Raylib

let velocity_system =
  System.for_each
    Sandstorm.((module Velocity) ^? (module Position))
    (fun id v p ->
      let v = Vector2.scale v (get_frame_time ()) in
      Position.set (Vector2.add p v) id)
;;
