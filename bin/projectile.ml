open Engine
open Engine.DefaultComponents
open Raylib

module C = struct
  type s = { velocity : Vector2.t }

  include (val Component.create () : Component.Sig with type t = s)
end

module S = struct
  let process id (c : C.s) pos =
    Position.set (Vector2.add pos @@ Vector2.scale c.velocity (get_frame_time ())) id
  ;;

  include (val System.create2 process (module C) (module Position))
end

let create pos velocity =
  Entity.create
    [ Position.create pos
    ; C.create { velocity }
    ; ShapeRenderer.C.create (Circle (5., Color.white))
    ; Collision.Shape.create (Circle 5.)
    ]
;;
