open Sandstorm
open Sandstorm_raylib_types
open Raylib

type s =
  { shape : Collision_shape.t
  ; mask : int
  ; mutable overlapping_entities : Entity.id_t list
  }

include (val Component.create () : Component.Sig with type t = s)

let sorted_list = ref []

let min_x id =
  let x =
    match Position.get_opt id with
    | Some v -> Vector2.x v
    | None -> 0.
  in
  match get_opt id with
  | Some s ->
    (match s.shape with
     | Circle r -> x -. r
     | Rect _ -> x)
  | None -> x
;;

let max_x id =
  let x =
    match Position.get_opt id with
    | Some v -> Vector2.x v
    | None -> 0.
  in
  match get_opt id with
  | Some s ->
    (match s.shape with
     | Circle r -> x +. r
     | Rect (w, _) -> x +. w)
  | None -> x
;;

let cmp_min_x id1 id2 = min_x id1 > min_x id2

let create c id =
  create c id;
  sorted_list := ListUtil.insert cmp_min_x id !sorted_list
;;

let remove id =
  sorted_list := List.filter (fun x -> x != id) !sorted_list;
  remove id
;;

let sort_axis () = sorted_list := ListUtil.insertion_sort cmp_min_x !sorted_list
let create_shape shape mask = create { shape; mask; overlapping_entities = [] }
