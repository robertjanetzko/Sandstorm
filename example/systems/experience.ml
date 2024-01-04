open Sandstorm
open Sandstorm_raylib_components
open Components
open Components.Experience
open Util

let pickup amount entity =
  match Experience.get_opt entity with
  | Some exp -> exp := !exp + amount
  | _ -> ()
;;

let pickup_system =
  System.for_each
    ((module Pickup) ^? (module Collision_impact))
    (fun id amount impact ->
      pickup amount impact.other;
      destroy_entity id)
;;

let ui_system =
  System.for_each
    ((module Experience) ^? (module Player.Tag))
    (fun _id amount _input ->
      let open Raylib in
      let w = get_render_width () in
      let h = get_render_height () in
      draw_rectangle 0 (h - 10) w 10 Color.gray;
      let exp_w = w * !amount / 1000 in
      draw_rectangle 0 (h - 10) exp_w 10 Color.darkblue;
      let msg = string_of_int !amount in
      let msg_w = Raylib.measure_text msg 10 in
      Raylib.draw_text msg ((w - msg_w) / 2) (h - 10) 10 Color.white)
;;

let level_up_system =
  System.for_each
    ((module Experience) ^& (module Level) ^? (module Player.Tag))
    (fun id amount level _input ->
      if !amount >= 100 * level
      then (
        Level.set (level + 1) id;
        UiHelper.showLevelUp ()))
;;
