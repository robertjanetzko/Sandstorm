open Sandstorm
open Sandstorm_raylib
open Components
open Raylib
open Raygui

let health_ui_system =
  System.for_each
    ((module Stats) ^? (module Player.Tag))
    (fun _id stats _input ->
      let open Raylib in
      let w = Window.width_i () in
      let h = Window.height_i () in
      draw_rectangle 0 (h - 20) w 10 Color.gray;
      let exp_w = int_of_float (float_of_int w *. stats.health /. stats.health_maximum) in
      draw_rectangle 0 (h - 20) exp_w 10 Color.red;
      let msg = Format.sprintf "%.0f / %.0f" stats.health stats.health_maximum in
      let msg_w = Raylib.measure_text msg 10 in
      Raylib.draw_text msg ((w - msg_w) / 2) (h - 20) 10 Color.white)
;;

let experience_ui_system =
  System.for_each
    ((module Experience.Experience) ^? (module Player.Tag))
    (fun _id amount _input ->
      let open Raylib in
      let w = Window.width_i () in
      let h = Window.height_i () in
      draw_rectangle 0 (h - 10) w 10 Color.gray;
      let exp_w = w * !amount / 1000 in
      draw_rectangle 0 (h - 10) exp_w 10 Color.darkblue;
      let msg = string_of_int !amount in
      let msg_w = Raylib.measure_text msg 10 in
      Raylib.draw_text msg ((w - msg_w) / 2) (h - 10) 10 Color.white)
;;

let skill_button id (x, y) key skill_id =
  let skill = Types.Skills.skills.(skill_id) in
  if button (Rectangle.create x y 200. 40.) skill.name || Raylib.is_key_pressed key
  then (
    Util.Player.player_apply_skill skill;
    destroy_entity id)
;;

let level_up_ui_system =
  System.for_each
    (query (module Components.Ui.LevelUp))
    (fun id menu ->
      skill_button id (90., 400.) Key.One menu.skill_id_1;
      skill_button id (300., 400.) Key.Two menu.skill_id_2;
      skill_button id (510., 400.) Key.Three menu.skill_id_3)
;;

let game_over_ui_system =
  System.for_each
    (query (module Components.Ui.GameOver))
    (fun id _menu ->
      draw_circle 100 100 50. Color.red;
      if button (Rectangle.create 100. 400. 200. 40.) "Restart"
      then (
        destroy_entity id;
        Util.Game.reset ()))
;;

let player_stats_system =
  System.for_each
    ((module Components.Player.Tag) ^? (module Components.Stats))
    (fun _id _p stats ->
      draw_text (Types.Stats.text stats) 10 40 8 Color.white
      (* draw_9_slice (Textures.get "resources/squares.png") 100 100 200 200 3 3 3 3 *))
;;

let group =
  System.create_group
    [| player_stats_system
     ; health_ui_system
     ; experience_ui_system
     ; level_up_ui_system
     ; game_over_ui_system
    |]
;;
