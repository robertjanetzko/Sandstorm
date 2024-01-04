open Sandstorm
open Raylib

type s = Vector2.t

include (val Component.create () : Component.Sig with type t = s)
