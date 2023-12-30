open Raylib
open DefaultComponents

type shape =
  | Circle of float * Color.t
  | Rect of float * float * Color.t

module C = struct
  type s = shape

  include (val Component.create () : Component.Sig with type t = s)
end

let system =
  System.create2
    (module Position)
    (module C)
    (fun _id pos -> function
      | Circle (r, c) -> draw_circle_v pos r c
      | Rect (w, h, c) -> draw_rectangle_v pos (Vector2.create w h) c)
;;
