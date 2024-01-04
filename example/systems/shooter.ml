open Sandstorm
open Sandstorm_raylib
open Components
open Raylib
open Util

let create cooldown = Shooter.create { timer = Timer.delay cooldown }

let create_projectile pos velocity =
  Entity.create
    [ Position.create pos
    ; Velocity.create velocity
    ; Projectile.create ()
    ; ShapeRenderer.C.create (Circle (5., Color.white))
    ; Collision.Shape.create
        { shape = Circle 5.
        ; mask = Utils.collision_mask [ Utils.collision_layer_projectile ]
        }
    ; Damage.C.create { amount = 1. }
    ]
;;

let fire pos =
  let p = Position.nearest Mob.Tag.is pos in
  match p with
  | Some (_, p) ->
    let dir = Vector2.subtract p pos |> Vector2.normalize in
    let velocity = Vector2.scale dir 600. in
    create_projectile pos velocity
  | _ -> ()
;;

let system =
  System.for_each
    ((module Shooter) ^? (module Position))
    (fun _id c pos -> if Timer.step c.timer then fire pos)
;;
