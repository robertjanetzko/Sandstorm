open Engine

module Health = struct
  type s =
    { mutable current : float
    ; mutable max : float
    }

  include (val Component.create () : Component.Sig with type t = s)
end

module Damage = struct
  type s = { amount : float }

  include (val Component.create () : Component.Sig with type t = s)
end

module ImpactDamage = struct
  let process _id (impact : Collision.Impact.s) (damage : Damage.s) =
    match Health.get_opt impact.other with
    | Some health -> health.current <- health.current -. damage.amount
    | _ -> ()
  ;;

  include (val System.create2 process (module Collision.Impact) (module Damage))
end

module Death = struct
  let process id (health : Health.t) = if health.current <= 0. then destroy_entity id

  include (val System.create1 process (module Health))
end
