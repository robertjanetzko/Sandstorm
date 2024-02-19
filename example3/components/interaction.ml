open Sandstorm

type s =
  { range : float
  ; mutable active : bool
  }

include (val Component.create () : Component.Sig with type t = s)
