open Engine

let level_up_ui_system =
  System.for_each
    (query (module Menu.LevelUp))
    (fun id _menu ->
      let open Raylib in
      draw_circle 100 100 50. Color.beige;
      if Raygui.button (Rectangle.create 100. 100. 200. 40.) "Hallo"
      then destroy_entity id)
;;

let game_over_ui_system =
  System.for_each
    (query (module Menu.GameOver))
    (fun id _menu ->
      let open Raylib in
      draw_circle 100 100 50. Color.red;
      if Raygui.button (Rectangle.create 100. 100. 200. 40.) "Restart"
      then (
        GameUtil.reset ();
        destroy_entity id))
;;
