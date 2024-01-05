open Sandstorm
open Sandstorm_raylib
open Sandstorm_raylib_components
open Components
open Util
open Raylib

let spawn_mob () =
  let player_pos = Util.Player.player_pos () in
  let angle = Random.float 6.28318530718 in
  let pos = Vector2.add player_pos @@ Vector2.rotate (Vector2.create 400. 0.) angle in
  Entity.create
    [ Position.create pos
    ; Velocity.create @@ Vector2.zero ()
      (* ; ShapeRenderer.C.create (Circle (20., Color.blue)) *)
    ; create_sprite_sheet
        (Textures.get "resources/Torch_Red.png")
        (Vector2.create 0. 0.)
        (Vector2.create 0.5 0.5)
        (7, 5)
    ; create_animator (7, 12)
    ; Flip_sprite.create ()
    ; create_animation_controller
        [ "idle", (0, 6); "walk", (7, 12) ]
        (fun id ->
          match Velocity.get_opt id with
          | Some v when Vector2.length v > 0. -> "walk"
          | _ -> "idle")
    ; Mob.Tag.create ()
    ; Collision_shape.create
        { shape = Circle 10.
        ; mask =
            Util.Collision.create_mask
              [ Util.Collision.collision_layer_projectile
              ; Util.Collision.collision_layer_player
              ]
        }
    ; Health.Health.create { current = 1.; max = 1. }
    ]
;;

let system =
  System.for_each
    (query (module Spawner))
    (fun _id spawner -> if Timer.step spawner.timer then spawn_mob ())
;;

let create_mob_spawner delay =
  Entity.create [ Spawner.create { timer = Timer.delay delay } ]
;;
