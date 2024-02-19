open Sandstorm
open Sandstorm_raylib_components
open Survival_components
open Raylib

let create_player () =
  Entity.create
    [ Position.create @@ Vector2.create 40. 30.
    ; Velocity.create @@ Vector2.zero ()
    ; Shape.create @@ Circle (10., Color.red)
    ; Player.Tag.create @@ () (* ; Follow_camera.create () *)
    ]
;;
