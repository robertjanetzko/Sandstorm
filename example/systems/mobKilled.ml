open Raylib
open Sandstorm
open Sandstorm_raylib
open Sandstorm_raylib_components
open Components
open Util

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
        ; mask = Utils.collision_mask [ Utils.collision_layer_experience ]
        }
    ; Experience.Pickup.create 100
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

let mob_killed_system =
  System.for_each
    ((module Position) ^& (module Health.Dead) ^? (module Mob.Tag))
    (fun _id pos _dead _mob ->
      spawn_experience_pickup pos;
      spawn_death_effect pos)
;;
