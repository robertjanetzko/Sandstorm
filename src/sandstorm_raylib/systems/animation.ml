open Sandstorm
open Sandstorm_raylib_components
open Sandstorm_raylib_types

let animation_system =
  System.for_each
    Sandstorm.((module Animator) ^? (module Sprite))
    (fun id a c ->
      if c.index < a.animation.from_index || c.index > a.animation.to_index
      then c.index <- a.animation.from_index;
      if Timer.step a.timer
      then (
        let new_index =
          if c.index + 1 <= a.animation.to_index
          then c.index + 1
          else (
            a.end_action id;
            a.animation.from_index)
        in
        c.index <- new_index))
;;
