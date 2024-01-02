open Raylib
open Default_components

module C = struct
  type s =
    { texture : Texture2D.t
    ; anchor : Vector2.t
    ; mutable scale : Vector2.t
    ; mutable index : int
    ; grid : int * int
    }

  let set_index index (c : s) = c.index <- index

  include (val Component.create () : Component.Sig with type t = s)
end

let create_sprite texture anchor scale =
  C.create { texture; anchor; scale; index = 0; grid = 1, 1 }
;;

let create_sprite_sheet texture anchor scale grid =
  C.create { texture; anchor; scale; index = 0; grid }
;;

type animation_t =
  { from_index : int
  ; to_index : int
  }

module Animator = struct
  type s =
    { mutable animation : animation_t
    ; end_action : int -> unit
    ; timer : Timer.t
    }

  include (val Component.create () : Component.Sig with type t = s)
end

let create_animator ?(end_action = fun _ -> ()) ?(duration = 0.1) (from_index, to_index) =
  Animator.create
    { animation = { from_index; to_index }; timer = Timer.start duration; end_action }
;;

let system =
  System.for_each
    Qq.((module Position) ^? (module C))
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

let animation_system =
  System.for_each
    Qq.((module Animator) ^? (module C))
    (fun id a c ->
      if c.index < a.animation.from_index || c.index > a.animation.to_index
      then c.index <- a.animation.from_index;
      if Timer.step a.timer
      then (
        let new_index =
          if c.index + 1 <= a.animation.to_index
          then c.index + 1
          else (
            a.end_action id;
            a.animation.from_index)
        in
        c.index <- new_index))
;;

(* draw_texture_v texture (Vector2.create x y) Color.white) *)

module FlipSprite = struct
  type s = unit

  include (val Component.create () : Component.Sig with type t = s)
end

let flip_sprite_system =
  System.for_each
    Qq.((module C) ^& (module Default_components.Velocity) ^? (module FlipSprite))
    (fun _id c v _flip ->
      Vector2.(
        if (x v < 0. && x c.scale > 0.) || (x v > 0. && x c.scale < 0.)
        then c.scale <- create (x c.scale *. -1.) (y c.scale)))
;;
