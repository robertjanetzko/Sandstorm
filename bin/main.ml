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
          ; Projectile.system
          ; Experience.Pickup.system
          ; Experience.level_up_system
          ; Health.system
          ; MobSpawner.mob_killed_system
          ; Health.death_system
          ; Projectile.cleanup_system
          ; Collision.cleanup_system
          ; MobSpawner.system
          ; Follow.system
         |]
    |]
  ;;

  let render_systems = [| FollowCamera.system; ShapeRenderer.system |]
  let ui_systems = [| Experience.ui_system; Menu.menu_ui_system |]

  let init () =
    Entity.create
      [ Position.create @@ Vector2.create 40. 30.
      ; ShapeRenderer.C.create @@ Circle (10., Color.red)
      ; Collision.Shape.create { shape = Circle 10.; mask = 2L }
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
