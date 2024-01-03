open Sandstorm
open Components

let impact_damage_system =
  System.for_each
    ((module Collision.Impact) ^? (module Damage.C))
    (fun _id impact damage ->
      match Health.Health.get_opt impact.other with
      | Some health -> health.current <- health.current -. damage.amount
      | _ -> ())
;;

let mob_damage_system =
  System.for_each
    ((module Health.Health) ^& (module Collision.Impact) ^? (module Player.Tag))
    (fun _id health impact _input ->
      if Mob.Tag.is impact.other then health.current <- health.current -. 100.)
;;
