open Raylib

let width () = float_of_int (get_render_width ()) /. (Vector2.x @@ get_window_scale_dpi ())

let height () =
  float_of_int (get_render_height ()) /. (Vector2.y @@ get_window_scale_dpi ())
;;

let width_i () = int_of_float @@ width ()
let height_i () = int_of_float @@ height ()
let size () = Vector2.create (width ()) (height ())
