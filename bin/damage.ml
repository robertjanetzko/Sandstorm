open Engine

module C = struct
  type s = { amount : float }

  include (val Component.create () : Component.Sig with type t = s)
end

let impact_damage_system =
  System.create2
    (module Collision.Impact)
    (module C)
    (fun _id impact damage ->
      match Health.C.get_opt impact.other with
      | Some health -> health.current <- health.current -. damage.amount
      | _ -> ())
;;

let mob_damage_system =
  System.create_q2
    (query2 (module Health.C) (module Collision.Impact) >&& (module PlayerInput.C))
    (fun _id health impact ->
      if MobSpawner.MobTag.is impact.other then health.current <- health.current -. 0.1)
;;
