open Sandstorm
open Sandstorm_raylib_components
open Components

let impact_damage_system =
  System.for_each
    ((module Collision_impact) ^? (module Damage))
    (fun _id impact damage ->
      impact.others
      |> query_iter
           ((module Mob.Tag) ^? (module Stats))
           (fun _id2 _mob stats -> stats.health <- stats.health -. damage.amount))
;;

let mob_damage_system =
  System.for_each
    ((module Player.Tag) ^& (module Collision_impact) ^? (module Stats))
    (fun _id _player impact stats ->
      impact.others
      |> query_iter
           (query (module Mob.Tag))
           (fun _id2 __mob -> stats.health <- stats.health -. 10.))
;;
