open Engine
open Engine.DefaultComponents
open Raylib

module VampireWorld = struct
  let systems : (module System.Sig) array =
    [| (module Collision.Detector)
     ; (module Components.ImpactDamage)
     ; (module PlayerInput.S)
     ; (module Shooter.S)
     ; (module Projectile.S)
     ; (module Projectile.Cleanup)
     ; (module Health.S)
     ; (module MobSpawner.DropExperience)
     ; (module Experience.Pickup.S)
     ; (module Health.Death)
     ; (module MobSpawner.S)
     ; (module Follow.S)
     ; (module FollowCamera.S)
     ; (module ShapeRenderer.S)
     ; (module Collision.Cleanup)
    |]
  ;;

  let init () =
    Entity.create
      [ Position.create @@ Vector2.create 40. 30.
      ; ShapeRenderer.C.create @@ Circle (10., Color.red)
      ; Collision.Shape.create { shape = Circle 10.; mask = 2L }
      ; PlayerInput.C.create @@ ()
      ; FollowCamera.C.create ()
      ; Health.C.create { current = 100.; max = 100. }
      ; Experience.C.create (ref 0)
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
