open Sandstorm

module Tag = struct
  type s = unit

  include (val Component.create () : Component.Sig with type t = s)
end
