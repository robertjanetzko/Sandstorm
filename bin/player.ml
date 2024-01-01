open Engine
open Engine.DefaultComponents
open Raylib

let create () =
  Entity.create
    [ Position.create @@ Vector2.create 40. 30.
    ; Velocity.create @@ Vector2.zero ()
      (* ; ShapeRenderer.C.create @@ Circle (10., Color.red) *)
    ; SpriteRenderer.create_sprite_sheet
        (Textures.get "resources/Warrior_Blue.png")
        (Vector2.create 0. 0.)
        (Vector2.create 0.5 0.5)
        (6, 8)
    ; SpriteRenderer.create_animator (0, 5)
    ; Animations.create_controller [ "idle", (0, 5); "walk", (6, 11) ]
      (* ; ShapeRenderer.C.create @@ Circle (20., Color.green) *)
    ; Collision.Shape.create
        { shape = Circle 20.
        ; mask =
            Util.collision_mask
              [ Util.collision_layer_player; Util.collision_layer_experience ]
        }
    ; PlayerInput.C.create @@ ()
    ; FollowCamera.C.create ()
    ; Health.C.create { current = 100.; max = 100. }
    ; Experience.C.create (ref 0)
    ; Experience.Level.create 1
    ; Shooter.create 2.
    ]
;;

let player_died_system =
  System.create_q
    (query (module PlayerInput.C) >& (module Health.Dead))
    (fun _id _input ->
      print_endline "DEAD";
      Menu.showGameOver ())
;;
