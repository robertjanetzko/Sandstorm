open Sandstorm
open Sandstorm_raylib
open Sandstorm_raylib_components
open Raylib

let reset () =
  Collision_impact.all () |> Seq.iter destroy_entity;
  Components.Mob.Tag.all () |> Seq.iter destroy_entity;
  Components.Projectile.all () |> Seq.iter destroy_entity;
  Components.Experience.Pickup.all () |> Seq.iter destroy_entity;
  Components.Player.Tag.all () |> Seq.iter destroy_entity;
  Components.Dead.all () |> Seq.iter destroy_entity;
  Player.create_player ()
;;

let spawn_experience_pickup pos =
  Entity.create
    [ Position.create pos
    ; create_sprite_sheet
        (Textures.get "resources/Coin.png")
        (Vector2.zero ())
        (Vector2.create 1. 1.)
        (4, 1)
    ; create_animator ~duration:0.2 (0, 3)
    ; Collision_shape.create
        { shape = Circle 3.
        ; mask = Collision.create_mask [ Collision.collision_layer_experience ]
        }
    ; Components.Experience.Pickup.create 100
    ]
;;

let spawn_death_effect pos =
  Entity.create
    [ Position.create pos
    ; create_sprite_sheet
        (Textures.get "resources/Dead.png")
        (Vector2.zero ())
        (Vector2.create 0.5 0.5)
        (7, 2)
    ; create_animator ~end_action:destroy_entity (0, 13)
    ]
;;
