open Sandstorm
open Raylib
open Raygui

let skill_button id (x, y) skill_id =
  let skill = Types.Skills.skills.(skill_id) in
  if button (Rectangle.create x y 200. 40.) skill.name
  then (
    Util.Player.player_apply_skill skill;
    destroy_entity id)
;;

let level_up_ui_system =
  System.for_each
    (query (module Components.Ui.LevelUp))
    (fun id menu ->
      skill_button id (90., 400.) menu.skill_id_1;
      skill_button id (300., 400.) menu.skill_id_2;
      skill_button id (510., 400.) menu.skill_id_3)
;;

let game_over_ui_system =
  System.for_each
    (query (module Components.Ui.GameOver))
    (fun id _menu ->
      draw_circle 100 100 50. Color.red;
      if button (Rectangle.create 100. 400. 200. 40.) "Restart"
      then (
        Util.Game.reset ();
        destroy_entity id))
;;

let player_stats_system =
  System.for_each
    ((module Components.Player.Tag) ^? (module Components.Stats))
    (fun _id _p stats -> draw_text (Types.Stats.text stats) 10 40 8 Color.white)
;;

let group =
  System.create_group [| player_stats_system; level_up_ui_system; game_over_ui_system |]
;;
