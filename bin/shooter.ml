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

module S = struct
  let fire pos =
    let p = Position.nearest MobSpawner.MobTag.is pos in
    match p with
    | Some (_, p) ->
      let dir = Vector2.subtract p pos |> Vector2.normalize in
      let velocity = Vector2.scale dir 100. in
      Projectile.create pos velocity
    | _ -> ()
  ;;

  let process _id (c : C.s) pos =
    if c.timer > 0.
    then c.timer <- c.timer -. Raylib.get_frame_time ()
    else (
      c.timer <- c.cooldown;
      fire pos)
  ;;

  include (val System.create2 process (module C) (module Position))
end

let create cooldown = C.create { cooldown; timer = cooldown }
