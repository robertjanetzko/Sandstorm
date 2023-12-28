open Raylib
open DefaultComponents

module C = struct
  type s = unit

  include (val Component.create () : Component.Sig with type t = s)
end

module S = struct
  let follow (state : Game.state_t) _id pos _cam = Camera2D.set_target state.camera pos

  include (val System.create2_w follow (module Position) (module C))
end
