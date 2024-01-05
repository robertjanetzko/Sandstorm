open Sandstorm
open Sandstorm_raylib
open Components

let system =
  System.for_each
    (query (module Spawner))
    (fun _id spawner -> if Timer.step spawner.timer then Util.Mob.spawn_mob ())
;;
