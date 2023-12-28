open Engine
open Engine.DefaultComponents
open Raylib

module VampireWorld = struct
  let systems : (module System.Sig) array =
    [| (module PlayerInput.S)
     ; (module Shooter.S)
     ; (module Projectile.S)
     ; (module MobSpawner.S)
     ; (module Follow.S)
     ; (module Collision.Cleanup)
     ; (module Collision.Detector)
     ; (module FollowCamera.S)
     ; (module ShapeRenderer.S)
    |]
  ;;

  let init () =
    Entity.create
      [ Position.create @@ Vector2.create 40. 30.
      ; ShapeRenderer.C.create @@ Circle (10., Color.red)
      ; PlayerInput.C.create @@ ()
      ; FollowCamera.C.create ()
      ; Shooter.create 2.
      ; Collision.Shape.create (Circle 10.)
      ];
    Entity.create
      [ Position.create @@ Vector2.create 140. 130.
      ; ShapeRenderer.C.create @@ Circle (20., Color.green)
      ; Collision.Shape.create (Circle 20.)
      ];
    Entity.create
      [ Position.create @@ Vector2.create 10. 130.
      ; ShapeRenderer.C.create @@ Rect (100., 120., Color.green)
      ];
    MobSpawner.create ()
  ;;
end

module Game = World.Make (VampireWorld)

let () = Game.run ()
