open Sandstorm

type s =
  { animations : (string, Sandstorm_raylib_types.Animation.t) Hashtbl.t
  ; mutable current : string
  ; next_anim : Entity.id_t -> string
  }

include (val Component.create () : Component.Sig with type t = s)
