open Engine
open Engine.DefaultComponents
open Raylib

module C = struct
  type s = unit

  include (val Component.create () : Component.Sig with type t = s)
end

let cleanup_system =
  System.create2
    (module Collision.Impact)
    (module C)
    (fun id _impact _c -> destroy_entity id)
;;

let create pos velocity =
  Entity.create
    [ Position.create pos
    ; Velocity.create velocity
    ; C.create ()
    ; ShapeRenderer.C.create (Circle (5., Color.white))
    ; Collision.Shape.create { shape = Circle 5.; mask = 1L }
    ; Damage.C.create { amount = 1. }
    ]
;;
