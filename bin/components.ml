open Engine

module Damage = struct
  type s = { amount : float }

  include (val Component.create () : Component.Sig with type t = s)
end

module ImpactDamage = struct
  let process _id (impact : Collision.Impact.s) (damage : Damage.s) =
    match Health.C.get_opt impact.other with
    | Some health -> health.current <- health.current -. damage.amount
    | _ -> ()
  ;;

  include (val System.create2 process (module Collision.Impact) (module Damage))
end
