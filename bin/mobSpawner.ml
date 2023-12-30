open Raylib
open Engine
open Engine.DefaultComponents

module MobTag = struct
  type s = unit

  include (val Component.create () : Component.Sig with type t = s)
end

module C = struct
  type s = { mutable timer : float }

  include (val Component.create () : Component.Sig with type t = s)
end

let spawn () =
  let player_pos = Util.player_pos () in
  let angle = Random.float 6.28318530718 in
  let pos = Vector2.add player_pos @@ Vector2.rotate (Vector2.create 400. 0.) angle in
  Entity.create
    [ Position.create pos
    ; ShapeRenderer.C.create (Circle (10., Color.blue))
    ; Follow.C.create ()
    ; MobTag.create ()
    ; Collision.Shape.create { shape = Circle 10.; mask = 1L }
    ; Health.C.create { current = 1.; max = 1. }
    ]
;;

let system =
  System.create
    (module C)
    (fun _id spawner ->
      if spawner.timer < 0.
      then (
        spawner.timer <- 1.;
        spawn ())
      else spawner.timer <- spawner.timer -. get_frame_time ())
;;

let create () = Entity.create [ C.create { timer = 1. } ]

let spawn_experience_pickup pos =
  Entity.create
    [ Position.create pos
    ; ShapeRenderer.C.create (Circle (3., Color.yellow))
    ; Collision.Shape.create { shape = Circle 3.; mask = 2L }
    ; Experience.Pickup.C.create 100
    ]
;;

let mob_killed_system =
  System.create3
    (module Health.Dead)
    (module MobTag)
    (module Position)
    (fun _id _dead _tag pos -> spawn_experience_pickup pos)
;;
