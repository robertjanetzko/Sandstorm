open Sandstorm
open Sandstorm_raylib
open Sandstorm_raylib_components
open Components
open Components.Experience
open Raylib

let create_player () =
  Entity.create
    [ Position.create @@ Vector2.create 40. 30.
    ; Velocity.create @@ Vector2.zero ()
      (* ; ShapeRenderer.C.create @@ Circle (10., Color.red) *)
    ; create_sprite_sheet
        (Textures.get "resources/Warrior_Blue.png")
        (Vector2.create 0. 0.)
        (Vector2.create 0.5 0.5)
        (6, 8)
    ; create_animator (0, 5)
    ; Flip_sprite.create ()
    ; create_animation_controller
        [ "idle", (0, 5); "walk", (6, 11) ]
        (fun id ->
          match Velocity.get_opt id with
          | Some v when Vector2.length v > 0. -> "walk"
          | _ -> "idle")
      (* ; ShapeRenderer.C.create @@ Circle (20., Color.green) *)
    ; Collision_shape.create
        { shape = Circle 20.
        ; mask =
            Collision.create_mask
              [ Collision.collision_layer_player; Collision.collision_layer_experience ]
        }
    ; Player.Tag.create @@ ()
    ; Follow_camera.create ()
    ; Stats.create Types.Stats.default
    ; Experience.create (ref 0)
    ; Level.create 1
    ; Components.Shooter.create { timer = Timer.delay 0.7 }
    ]
;;

let player_pos () =
  match Player.Tag.first () with
  | Some (player_id, _) ->
    (match Position.get_opt player_id with
     | Some player_pos -> player_pos
     | None -> Raylib.Vector2.zero ())
  | None -> Raylib.Vector2.zero ()
;;

let player_apply_skill (skill : Types.Skills.t) =
  query_each
    ((module Player.Tag) ^? (module Stats))
    (fun _id _p stats -> Types.Stats.combine stats skill.stats)
;;
