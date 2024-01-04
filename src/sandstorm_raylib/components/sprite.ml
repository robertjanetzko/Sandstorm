open Sandstorm
open Raylib

type s =
  { texture : Texture2D.t
  ; anchor : Vector2.t
  ; mutable scale : Vector2.t
  ; mutable index : int
  ; grid : int * int
  }

let set_index index (c : s) = c.index <- index

include (val Component.create () : Component.Sig with type t = s)
