open Sandstorm

type s =
  { others : Entity.id_t list
  ; position : Raylib.Vector2.t
  }

include (val Component.create () : Component.Sig with type t = s)
