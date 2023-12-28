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
  let process _id (c : C.s) pos =
    if c.timer > 0.
    then c.timer <- c.timer -. Raylib.get_frame_time ()
    else (
      c.timer <- c.cooldown;
      Projectile.create pos (Vector2.create 100. 0.))
  ;;

  include (val System.create2 process (module C) (module Position))
end

let create cooldown = C.create { cooldown; timer = cooldown }
