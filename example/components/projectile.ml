open Sandstorm
open Sandstorm_raylib

type s =
  { lifetime : Timer.t
  ; mutable piercing : int
  }

include (val Component.create () : Component.Sig with type t = s)
