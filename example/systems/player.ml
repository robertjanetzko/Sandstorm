open Sandstorm
open Sandstorm_raylib_components
open Raylib
open Components
open Components.Health
open Util

let input_direction () =
  let open Raylib in
  let x = if is_key_down Key.A then -1. else if is_key_down Key.D then 1. else 0. in
  let y = if is_key_down Key.W then -1. else if is_key_down Key.S then 1. else 0. in
  Vector2.create x y |> Vector2.normalize
;;

let system =
  System.for_each
    ((module Player.Tag) ^? (module Velocity))
    (fun id _input _vel ->
      let dir = input_direction () in
      let vel = Vector2.scale dir 150. in
      Velocity.set vel id)
;;

let player_died_system =
  System.for_each
    ((module Player.Tag) ^? (module Dead))
    (fun _id _input _dead -> UiHelper.showGameOver ())
;;
