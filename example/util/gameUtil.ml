open Sandstorm
open Sandstorm_raylib
open Components
open Components.Health
open Components.Experience
open Raylib

let create_player () =
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
    ; SpriteRenderer.FlipSprite.create ()
    ; Animation.create_controller [ "idle", (0, 5); "walk", (6, 11) ]
      (* ; ShapeRenderer.C.create @@ Circle (20., Color.green) *)
    ; Collision.Shape.create
        { shape = Circle 20.
        ; mask =
            Utils.collision_mask
              [ Utils.collision_layer_player; Utils.collision_layer_experience ]
        }
    ; Player.Tag.create @@ ()
    ; FollowCamera.C.create ()
    ; Health.create { current = 100.; max = 100. }
    ; Experience.create (ref 0)
    ; Level.create 1
    ; Components.Shooter.create { timer = Timer.delay 0.7 }
    ]
;;

let reset () =
  Mob.Tag.all () |> Seq.iter destroy_entity;
  Projectile.all () |> Seq.iter destroy_entity;
  Pickup.all () |> Seq.iter destroy_entity;
  create_player ()
;;
