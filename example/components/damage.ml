open Sandstorm

module C = struct
  type s = { amount : float }

  include (val Component.create () : Component.Sig with type t = s)
end
