open Engine

module C = struct
  type s =
    { mutable current : float
    ; mutable max : float
    }

  include (val Component.create () : Component.Sig with type t = s)
end

module Dead = struct
  type s = unit

  include (val Component.create () : Component.Sig with type t = s)
end

let system =
  System.create1r
    (module C)
    (fun id health -> if health.current <= 0. then Dead.set () id)
;;

let death_system = System.create1r (module Dead) (fun id _dead -> destroy_entity id)
