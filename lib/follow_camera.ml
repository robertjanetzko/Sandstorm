open Raylib
open Default_components

module C = struct
  type s = unit

  include (val Component.create () : Component.Sig with type t = s)
end

let system =
  System.create2w
    (module Position)
    (module C)
    (fun state _id pos _cam -> Camera2D.set_target state.camera pos)
;;
