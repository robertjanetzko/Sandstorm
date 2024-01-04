open Sandstorm
open Sandstorm_raylib_components

let system =
  System.for_each
    ((module Animation_controller) ^? (module Animator))
    (fun id ctrl anim ->
      ctrl.current <- ctrl.next_anim id;
      anim.animation <- Hashtbl.find ctrl.animations ctrl.current)
;;
