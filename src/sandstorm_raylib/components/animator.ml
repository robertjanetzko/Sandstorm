open Sandstorm
open Sandstorm_raylib_types

type s =
  { mutable animation : Animation.t
  ; end_action : int -> unit
  ; timer : Timer.t
  }

include (val Component.create () : Component.Sig with type t = s)
