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

module S = struct
  let process id (health : C.s) = if health.current <= 0. then Dead.create () id

  include (val System.create1 process (module C))
end

module Death = struct
  let process id _ = destroy_entity id

  include (val System.create1 process (module Dead))
end
