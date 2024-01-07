open Sandstorm
open Sandstorm_raylib
open Sandstorm_raylib_components
open Raylib

let start () =
  Player.create_player ();
  Mob.create_mob_spawner ~spawn_rate:0.3
;;

let reset () =
  destroy_all_entities ();
  start ()
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
    ; Collision_shape.create_shape
        (Circle 3.)
        (Collision.create_mask [ Collision.collision_layer_experience ])
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
