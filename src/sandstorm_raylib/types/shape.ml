open Raylib

type t =
  | Circle of float * Color.t
  | Rect of float * float * Color.t
