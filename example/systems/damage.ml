open Sandstorm
open Sandstorm_raylib_components
open Components

let impact_damage_system =
  System.for_each
    ((module Collision_impact) ^? (module Damage))
    (fun _id impact damage ->
      match Stats.get_opt impact.other with
      | Some stats -> stats.health <- stats.health -. damage.amount
      | _ -> ())
;;

let mob_damage_system =
  System.for_each
    ((module Player.Tag) ^& (module Collision_impact) ^? (module Stats))
    (fun _id _player impact stats ->
      if Mob.Tag.is impact.other then stats.health <- stats.health -. 10.)
;;
