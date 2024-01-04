open Sandstorm
open Sandstorm_raylib_components
open Raylib

let system =
  System.for_each
    Sandstorm.((module Position) ^? (module Sprite))
    (fun _id pos { texture; anchor; scale; index; grid = cols, rows } ->
      let w = Texture.width texture / cols in
      let h = Texture.height texture / rows in
      let xi = index mod cols in
      let yi = index / cols in
      let sign x = if x < 0. then -1. else 1. in
      let rect =
        Rectangle.create
          (float_of_int (w * xi))
          (float_of_int (h * yi))
          (float_of_int w *. (sign @@ Vector2.x scale))
          (float_of_int h *. (sign @@ Vector2.y scale))
      in
      let dw = float_of_int w *. (abs_float @@ Vector2.x scale) in
      let dh = float_of_int h *. Vector2.y scale in
      let x = Vector2.x pos +. ((Vector2.x anchor -. 0.5) *. dw) in
      let y = Vector2.y pos +. ((Vector2.y anchor -. 0.5) *. dh) in
      let rect2 = Rectangle.create x y dw dh in
      draw_texture_pro texture rect rect2 (Vector2.create 0. 0.) 0. Color.white)
;;
