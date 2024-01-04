open Sandstorm
open Sandstorm_raylib_components
open Raylib

let flip_sprite_system =
  System.for_each
    Sandstorm.((module Sprite) ^& (module Velocity) ^? (module Flip_sprite))
    (fun _id c v _flip ->
      Vector2.(
        if (x v < 0. && x c.scale > 0.) || (x v > 0. && x c.scale < 0.)
        then c.scale <- create (x c.scale *. -1.) (y c.scale)))
;;
