open Sandstorm
open Sandstorm_raylib
open Components
open Components.Health

let system =
  System.for_each
    (query (module Health))
    (fun id health -> if health.current <= 0. then Dead.set () id)
;;

let death_system =
  System.for_each (query (module Dead)) (fun id _dead -> destroy_entity id)
;;

let ui_system =
  System.for_each
    ((module Health) ^? (module Player.Tag))
    (fun _id health _input ->
      let open Raylib in
      let w = get_render_width () in
      let h = get_render_height () in
      draw_rectangle 0 (h - 20) w 10 Color.gray;
      let exp_w = int_of_float (float_of_int w *. health.current /. health.max) in
      draw_rectangle 0 (h - 20) exp_w 10 Color.red;
      let msg = string_of_float health.current in
      let msg_w = Raylib.measure_text msg 10 in
      Raylib.draw_text msg ((w - msg_w) / 2) (h - 20) 10 Color.white)
;;
