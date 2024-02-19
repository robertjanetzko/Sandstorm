open Sandstorm
open Sandstorm_raylib_components
open Raylib

let create_obj () =
  Entity.create
    [ Position.create @@ Vector2.create 140. 30.
    ; Shape.create @@ Circle (10., Color.blue)
    ; Survival_components.Interaction.create { range = 100.; active = false }
    ]
;;

let start () =
  create_obj ();
  Player.create_player ()
;;
