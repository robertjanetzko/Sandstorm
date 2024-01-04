open Sandstorm
open Sandstorm_raylib_components
open Raylib

let system =
  System.for_each
    Sandstorm.((module Position) ^? (module Shape))
    (fun _id pos -> function
      | Circle (r, c) -> draw_circle_v pos r c
      | Rect (w, h, c) -> draw_rectangle_v pos (Vector2.create w h) c)
;;
