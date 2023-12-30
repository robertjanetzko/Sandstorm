open Engine

module C = struct
  type s = unit

  include (val Component.create () : Component.Sig with type t = s)
end

let show () = Entity.create [ C.create () ]

let menu_ui_system =
  System.create_q
    (query (module C))
    (fun id _menu ->
      let open Raylib in
      draw_circle 100 100 50. Color.beige;
      if Raygui.button (Rectangle.create 100. 100. 200. 40.) "Hallo"
      then destroy_entity id)
;;
