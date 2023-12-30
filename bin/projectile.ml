open Engine
open Engine.DefaultComponents
open Raylib

module C = struct
  type s = { velocity : Vector2.t }

  include (val Component.create () : Component.Sig with type t = s)
end

let system =
  System.create2
    (module C)
    (module Position)
    (fun id (c : C.s) pos ->
      Position.set (Vector2.add pos @@ Vector2.scale c.velocity (get_frame_time ())) id)
;;

let cleanup_system =
  System.create2
    (module Collision.Impact)
    (module C)
    (fun id _impact _c -> destroy_entity id)
;;

let create pos velocity =
  Entity.create
    [ Position.create pos
    ; C.create { velocity }
    ; ShapeRenderer.C.create (Circle (5., Color.white))
    ; Collision.Shape.create { shape = Circle 5.; mask = 1L }
    ; Damage.C.create { amount = 1. }
    ]
;;
