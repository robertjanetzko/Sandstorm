open Sandstorm

type s =
  { other : Entity.id_t
  ; position : Raylib.Vector2.t
  }

include (val Component.create () : Component.Sig with type t = s)
