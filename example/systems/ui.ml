open Sandstorm
open Sandstorm_raylib
open Raylib
open Raygui

let skill_button id (x, y) skill_id =
  let skill = Types.Skills.skills.(skill_id) in
  if button (Rectangle.create x y 200. 40.) skill.name then destroy_entity id
;;

let level_up_ui_system =
  System.for_each
    (query (module Components.Ui.LevelUp))
    (fun id menu ->
      skill_button id (100., 100.) menu.skill_id_1;
      skill_button id (300., 100.) menu.skill_id_2;
      skill_button id (500., 100.) menu.skill_id_3)
;;

let game_over_ui_system =
  System.for_each
    (query (module Components.Ui.GameOver))
    (fun id _menu ->
      draw_circle 100 100 50. Color.red;
      if button (Rectangle.create 100. 100. 200. 40.) "Restart"
      then (
        Util.GameUtil.reset ();
        destroy_entity id))
;;
