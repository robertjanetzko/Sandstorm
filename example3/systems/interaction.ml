open Sandstorm
open Sandstorm_raylib_components
open Survival_components
open Raylib

let system =
  System.for_each
    ((module Position) ^? (module Interaction))
    (fun _id pos interaction ->
      query_first
        ((module Position) ^? (module Player.Tag))
        (fun _id player_pos _ ->
          let in_range = Vector2.distance pos player_pos < interaction.range in
          interaction.active <- in_range))
;;

let ui_system =
  System.for_each
    ((module Position) ^? (module Interaction))
    (fun _id pos interaction ->
      if interaction.active
      then
        Raylib.draw_text
          "Press F"
          (int_of_float @@ Vector2.x pos)
          (int_of_float @@ Vector2.y pos)
          10
          Color.white)
;;
