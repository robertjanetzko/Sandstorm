open Sandstorm

module C = struct
  type s = { amount : float }

  include (val Component.create () : Component.Sig with type t = s)
end

let impact_damage_system =
  System.for_each
    ((module Collision.Impact) ^? (module C))
    (fun _id impact damage ->
      match Health.C.get_opt impact.other with
      | Some health -> health.current <- health.current -. damage.amount
      | _ -> ())
;;

let mob_damage_system =
  System.for_each
    ((module Health.C) ^& (module Collision.Impact) ^? (module PlayerInput.C))
    (fun _id health impact _input ->
      if MobSpawner.MobTag.is impact.other then health.current <- health.current -. 100.)
;;
