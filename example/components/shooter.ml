open Sandstorm
open Sandstorm_raylib

type s = { timer : Timer.t }

include (val Component.create () : Component.Sig with type t = s)
