open Raylib
open Engine
open Engine.DefaultComponents

module MobTag = struct
  type s = unit

  include (val Component.create () : Component.Sig with type t = s)
end

module C = struct
  type s = { timer : Timer.t }

  include (val Component.create () : Component.Sig with type t = s)
end

let spawn () =
  let player_pos = Util.player_pos () in
  let angle = Random.float 6.28318530718 in
  let pos = Vector2.add player_pos @@ Vector2.rotate (Vector2.create 400. 0.) angle in
  Entity.create
    [ Position.create pos
    ; Velocity.create @@ Vector2.zero ()
      (* ; ShapeRenderer.C.create (Circle (20., Color.blue)) *)
    ; SpriteRenderer.create_sprite_sheet
        (Textures.get "resources/Torch_Red.png")
        (Vector2.create 0. 0.)
        (Vector2.create 0.5 0.5)
        (7, 5)
    ; SpriteRenderer.create_animator (7, 12)
    ; Animations.create_controller [ "idle", (0, 6); "walk", (7, 12) ]
    ; Follow.C.create ()
    ; MobTag.create ()
    ; Collision.Shape.create { shape = Circle 10.; mask = 1L }
    ; Health.C.create { current = 1.; max = 1. }
    ]
;;

let system =
  System.create (module C) (fun _id spawner -> if Timer.step spawner.timer then spawn ())
;;

let create () = Entity.create [ C.create { timer = Timer.delay 1. } ]

let spawn_experience_pickup pos =
  Entity.create
    [ Position.create pos
    ; SpriteRenderer.create_sprite_sheet
        (Textures.get "resources/Coin.png")
        (Vector2.zero ())
        (Vector2.create 1. 1.)
        (4, 1)
    ; SpriteRenderer.create_animator ~duration:0.2 (0, 3)
    ; Collision.Shape.create { shape = Circle 3.; mask = 2L }
    ; Experience.Pickup.C.create 100
    ]
;;

let spawn_death_effect pos =
  Entity.create
    [ Position.create pos
    ; SpriteRenderer.create_sprite_sheet
        (Textures.get "resources/Dead.png")
        (Vector2.zero ())
        (Vector2.create 0.5 0.5)
        (7, 2)
    ; SpriteRenderer.create_animator ~end_action:destroy_entity (0, 13)
    ]
;;

let mob_killed_system =
  System.create_q
    (query (module Position) >& (module Health.Dead) >& (module MobTag))
    (fun _id pos ->
      spawn_experience_pickup pos;
      spawn_death_effect pos)
;;
