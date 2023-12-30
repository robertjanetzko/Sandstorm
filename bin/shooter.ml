open Engine
open Engine.DefaultComponents
open Raylib

module C = struct
  type s =
    { cooldown : float
    ; mutable timer : float
    }

  include (val Component.create () : Component.Sig with type t = s)
end

let create cooldown = C.create { cooldown; timer = cooldown }

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
  System.create2
    (module C)
    (module Position)
    (fun _id c pos ->
      if c.timer > 0.
      then c.timer <- c.timer -. Raylib.get_frame_time ()
      else (
        c.timer <- c.cooldown;
        fire pos))
;;
