open Sandstorm

type s = Types.Stats.t

include (val Component.create () : Component.Sig with type t = s)
