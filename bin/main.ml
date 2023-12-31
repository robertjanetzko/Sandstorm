open Engine
open Engine.DefaultComponents
open Raylib

module VampireWorld = struct
  let no_menu _state = Option.is_none @@ Menu.C.first ()

  let systems =
    [| System.create_group
         ~condition:no_menu
         [| Collision.system
          ; Damage.impact_damage_system
          ; PlayerInput.system
          ; Shooter.system
          ; Experience.Pickup.system
          ; Experience.level_up_system
          ; Health.system
          ; MobSpawner.mob_killed_system
          ; Health.death_system
          ; Projectile.cleanup_system
          ; Collision.cleanup_system
          ; MobSpawner.system
          ; Follow.system
          ; velocity_system
          ; SpriteRenderer.flip_sprite_system
          ; Animations.system
          ; SpriteRenderer.animation_system
         |]
     ; FollowCamera.system
    |]
  ;;

  let render_systems = [| SpriteRenderer.system; ShapeRenderer.system |]
  let ui_systems = [| Experience.ui_system; Menu.menu_ui_system |]

  let init () =
    Entity.create
      [ Position.create @@ Vector2.create 40. 30.
      ; Velocity.create @@ Vector2.zero ()
        (* ; ShapeRenderer.C.create @@ Circle (10., Color.red) *)
      ; SpriteRenderer.create_sprite_sheet
          (Textures.player ())
          (Vector2.create 0. 0.)
          (Vector2.create 0.5 0.5)
          (6, 8)
      ; SpriteRenderer.create_animator 0 5 0.1
      ; Animations.create_controller [ "idle", (0, 5); "walk", (6, 11) ]
        (* ; ShapeRenderer.C.create @@ Circle (20., Color.green) *)
      ; Collision.Shape.create { shape = Circle 20.; mask = 2L }
      ; PlayerInput.C.create @@ ()
      ; FollowCamera.C.create ()
      ; Health.C.create { current = 100.; max = 100. }
      ; Experience.C.create (ref 0)
      ; Experience.Level.create 1
      ; Shooter.create 2.
      ];
    (* Entity.create
       [ Position.create @@ Vector2.create 140. 130.
      ; ShapeRenderer.C.create @@ Circle (20., Color.green)
      ; Collision.Shape.create (Circle 20.)
      ]; *)
    Entity.create
      [ Position.create @@ Vector2.create 10. 130.
      ; ShapeRenderer.C.create @@ Rect (100., 120., Color.green)
      ];
    MobSpawner.create ()
  ;;
end

module Game = World.Make (VampireWorld)

let () = Game.run ()
