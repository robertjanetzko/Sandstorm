open Sandstorm

module Experience = struct
  type s = int ref

  include (val Component.create () : Component.Sig with type t = s)
end

module Level = struct
  type s = int

  include (val Component.create () : Component.Sig with type t = s)
end

module Pickup = struct
  type s = int

  include (val Component.create () : Component.Sig with type t = s)
end
