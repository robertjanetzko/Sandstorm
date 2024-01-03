open Sandstorm

module Health = struct
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
