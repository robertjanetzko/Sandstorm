open Sandstorm
open Sandstorm_raylib_components
open Survival_components
open Raylib

let system =
  System.create_group
    [| System.base Interaction.Active.clear
     ; System.for_each
         (query (module Interaction.Progress))
         (fun id progress ->
           let progress =
             { progress with
               value =
                 max 0. (progress.value -. (progress.decay *. Raylib.get_frame_time ()))
             }
           in
           if progress.value <= 0.
           then Interaction.Progress.remove id
           else Interaction.Progress.set progress id)
     ; System.for_each
         ((module Position) ^? (module Player.Tag))
         (fun _id player_pos _ ->
           let min_dist = ref Float.max_float in
           let closest_interaction = ref None in
           query_each
             ((module Position) ^? (module Interaction))
             (fun id pos interaction ->
               let distance = Vector2.distance pos player_pos in
               let in_range = distance < interaction.range in
               if in_range && distance < !min_dist
               then (
                 min_dist := distance;
                 closest_interaction := Some (id, interaction)));
           match !closest_interaction with
           | Some (id, interaction) ->
             Interaction.Active.set () id;
             (match interaction.single with
              | true when Raylib.is_key_pressed Key.F -> interaction.action id
              | false when Raylib.is_key_down Key.F -> interaction.action id
              | _ -> ())
           | None -> ())
    |]
;;

let ui_system =
  System.create_group
    [| System.for_each
         ((module Position) ^? (module Interaction.Progress))
         (fun _id pos progress ->
           let w = 20. in
           let p = w *. min 1. (progress.value /. progress.max) in
           Raylib.draw_line_ex
             (Vector2.subtract pos (Vector2.create (w /. 2.) 0.))
             (Vector2.add pos (Vector2.create (w /. 2.) 0.))
             5.
             Color.black;
           Raylib.draw_line_ex
             (Vector2.subtract pos (Vector2.create (w /. 2.) 0.))
             (Vector2.subtract pos (Vector2.create (w /. 2.) 0.)
              |> Vector2.add (Vector2.create p 0.))
             5.
             Color.yellow)
     ; System.for_each
         ((module Position) ^& (module Interaction) ^? (module Interaction.Active))
         (fun _id pos _interaction _tag ->
           Raylib.draw_text
             "Press F"
             (int_of_float @@ Vector2.x pos)
             (int_of_float @@ Vector2.y pos)
             10
             Color.white)
    |]
;;
