open Sandstorm
open Sandstorm_raylib
open Components
open Raylib

let system =
  System.for_each
    ((module Animation.Controller) ^? (module SpriteRenderer.Animator))
    (fun id ctrl anim ->
      let next_anim =
        match Velocity.get_opt id with
        | Some v when Vector2.length v > 0. -> "walk"
        | _ -> "idle"
      in
      ctrl.current <- next_anim;
      anim.animation <- Hashtbl.find ctrl.animations ctrl.current)
;;
