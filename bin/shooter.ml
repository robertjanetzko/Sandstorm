open Engine
open Engine.DefaultComponents
open Raylib

module C = struct
  type s = { timer : Timer.t }

  include (val Component.create () : Component.Sig with type t = s)
end

let create cooldown = C.create { timer = Timer.delay cooldown }

let fire pos =
  let p = Position.nearest MobSpawner.MobTag.is pos in
  match p with
  | Some (_, p) ->
    let dir = Vector2.subtract p pos |> Vector2.normalize in
    let velocity = Vector2.scale dir 600. in
    Projectile.create pos velocity
  | _ -> ()
;;

let system =
  System.for_each
    ((module C) ^? (module Position))
    (fun _id c pos -> if Timer.step c.timer then fire pos)
;;
