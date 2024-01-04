open Sandstorm

type s = unit

include (val Component.create () : Component.Sig with type t = s)
