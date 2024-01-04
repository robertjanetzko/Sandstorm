open Sandstorm
open Sandstorm_raylib_types

type s = { timer : Timer.t }

include (val Component.create () : Component.Sig with type t = s)
