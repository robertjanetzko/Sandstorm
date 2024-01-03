open Sandstorm
open Sandstorm.DefaultComponents
open Components
open Util
open Raylib

let spawn_mob () =
  let player_pos = Utils.player_pos () in
  let angle = Random.float 6.28318530718 in
  let pos = Vector2.add player_pos @@ Vector2.rotate (Vector2.create 400. 0.) angle in
  Entity.create
    [ Position.create pos
    ; Velocity.create @@ Vector2.zero ()
      (* ; ShapeRenderer.C.create (Circle (20., Color.blue)) *)
    ; SpriteRenderer.create_sprite_sheet
        (Textures.get "resources/Torch_Red.png")
        (Vector2.create 0. 0.)
        (Vector2.create 0.5 0.5)
        (7, 5)
    ; SpriteRenderer.create_animator (7, 12)
    ; SpriteRenderer.FlipSprite.create ()
    ; Animation.create_controller [ "idle", (0, 6); "walk", (7, 12) ]
    ; Mob.Tag.create ()
    ; Collision.Shape.create
        { shape = Circle 10.
        ; mask =
            Utils.collision_mask
              [ Utils.collision_layer_projectile; Utils.collision_layer_player ]
        }
    ; Health.Health.create { current = 1.; max = 1. }
    ]
;;

let system =
  System.for_each
    (query (module Spawner))
    (fun _id spawner -> if Timer.step spawner.timer then spawn_mob ())
;;

let create delay = Entity.create [ Spawner.create { timer = Timer.delay delay } ]
