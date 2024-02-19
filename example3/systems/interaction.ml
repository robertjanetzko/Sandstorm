open Sandstorm
open Sandstorm_raylib_components
open Survival_components
open Raylib

let system =
  System.for_each
    ((module Position) ^? (module Player.Tag))
    (fun _id player_pos _ ->
      let min_dist = ref Float.max_float in
      let closest_interaction = ref None in
      query_each
        ((module Position) ^? (module Interaction))
        (fun id pos interaction ->
          interaction.active <- false;
          let distance = Vector2.distance pos player_pos in
          let in_range = distance < interaction.range in
          if in_range && distance < !min_dist
          then (
            min_dist := distance;
            closest_interaction := Some (id, interaction)));
      match !closest_interaction with
      | Some (id, interaction) ->
        interaction.active <- true;
        if Raylib.is_key_pressed Key.F then interaction.action id
      | None -> ())
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
