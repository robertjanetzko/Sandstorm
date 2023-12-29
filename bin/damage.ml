open Engine

module C = struct
  type s = { amount : float }

  include (val Component.create () : Component.Sig with type t = s)
end

let impact_damage_system =
  System.create2r
    (module Collision.Impact)
    (module C)
    (fun _id impact damage ->
      match Health.C.get_opt impact.other with
      | Some health -> health.current <- health.current -. damage.amount
      | _ -> ())
;;
