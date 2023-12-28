open Raylib
open Engine
open Engine.DefaultComponents

module C = struct
  type s = { mutable timer : float }

  include (val Component.create () : Component.Sig with type t = s)
end

module S = struct
  let spawn () =
    let player_pos = Util.player_pos () in
    let angle = Random.float 6.28318530718 in
    let pos = Vector2.add player_pos @@ Vector2.rotate (Vector2.create 600. 0.) angle in
    Entity.create
      [ Position.create pos
      ; ShapeRenderer.C.create (Circle (10., Color.blue))
      ; Follow.C.create ()
      ]
  ;;

  let proc _id (spawner : C.t) =
    if spawner.timer < 0.
    then (
      spawner.timer <- 1.;
      spawn ())
    else spawner.timer <- spawner.timer -. get_frame_time ()
  ;;

  include (val System.create1 proc (module C))
end

let create () = Entity.create [ C.create { timer = 1. } ]
