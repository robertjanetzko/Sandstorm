open Sandstorm
open Sandstorm_raylib
open Sandstorm_raylib_components
open Components
open Raylib
open Util

let create cooldown = Shooter.create { timer = Timer.delay cooldown }

let create_projectile pos velocity =
  Entity.create
    [ Position.create pos
    ; Velocity.create velocity
    ; Projectile.create ()
    ; Shape.create (Circle (5., Color.white))
    ; Collision_shape.create
        { shape = Circle 5.
        ; mask = Utils.collision_mask [ Utils.collision_layer_projectile ]
        }
    ; Damage.C.create { amount = 1. }
    ]
;;

let fire pos =
  let p = nearest_position (query (module Mob.Tag)) pos in
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
