open Sandstorm

type s =
  { range : float
  ; mutable active : bool
  ; action : Entity.id_t -> unit
  }

include (val Component.create () : Component.Sig with type t = s)
