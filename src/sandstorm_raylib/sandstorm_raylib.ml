module World = World
module Textures = Textures
module Sounds = Sounds
module Music_streams = Music_streams
module Window = Window
include Sandstorm_raylib_types
open Sandstorm
open Sandstorm_raylib_components

let create_sprite texture anchor scale =
  Sprite.create { texture; anchor; scale; index = 0; grid = 1, 1 }
;;

let create_sprite_sheet texture anchor scale grid =
  Sprite.create { texture; anchor; scale; index = 0; grid }
;;

let create_animator ?(end_action = fun _ -> ()) ?(duration = 0.1) (from_index, to_index) =
  Animator.create
    { animation = { from_index; to_index }; timer = Timer.start duration; end_action }
;;

let create_animation_controller
  (animation_list : (string * (int * int)) list)
  (next_anim : Entity.id_t -> string)
  =
  let animations = Hashtbl.create @@ List.length animation_list in
  let current =
    match List.nth animation_list 0 with
    | name, _ -> name
  in
  let ctrl = Animation_controller.create { animations; current; next_anim } in
  List.iter
    (fun (name, (from_index, to_index)) ->
      Hashtbl.add animations name { from_index; to_index })
    animation_list;
  ctrl
;;

let nearest_position query pos =
  let t =
    Position.fold
      (fun entity_id entity_pos acc ->
        if query_matches entity_id query
        then (
          let dist = Raylib.Vector2.distance pos entity_pos in
          match acc with
          | None -> Some (entity_id, entity_pos, dist)
          | Some (_, _, d) when dist < d -> Some (entity_id, entity_pos, dist)
          | t -> t)
        else acc)
      None
  in
  match t with
  | Some (id, pos, _) -> Some (id, pos)
  | _ -> None
;;

let draw_9_slice texture x y w h inset_left inset_top inset_right inset_bottom =
  match inset_left, inset_top, inset_right, inset_bottom with
  | il, it, ir, ib ->
    let open Raylib in
    let tw = Texture.width texture in
    let th = Texture.height texture in
    let rect x y w h =
      Rectangle.create (float_of_int x) (float_of_int y) (float_of_int w) (float_of_int h)
    in
    (* center *)
    let src = rect il it (tw - il - ir) (th - it - ib) in
    let dst = rect (x + il) (y + it) (w - il - ir) (h - it - ib) in
    draw_texture_pro texture src dst (Vector2.create 0. 0.) 0. Color.white;
    (* top left*)
    let src = rect 0 0 il it in
    let dst = rect x y il it in
    draw_texture_pro texture src dst (Vector2.create 0. 0.) 0. Color.white;
    (* top *)
    let src = rect il 0 (tw - il - ir) it in
    let dst = rect (x + il) y (w - il - ir) it in
    draw_texture_pro texture src dst (Vector2.create 0. 0.) 0. Color.white;
    (* top right *)
    let src = rect (tw - ir) 0 ir it in
    let dst = rect (x + w - ir) y ir it in
    draw_texture_pro texture src dst (Vector2.create 0. 0.) 0. Color.white;
    (* right *)
    let src = rect (tw - ir) it ir (th - it - ib) in
    let dst = rect (x + w - ir) (y + it) ir (w - it - ib) in
    draw_texture_pro texture src dst (Vector2.create 0. 0.) 0. Color.white;
    (* bottom right *)
    let src = rect (tw - ir) (th - ib) ir ib in
    let dst = rect (x + w - ir) (y + h - ib) ir ib in
    draw_texture_pro texture src dst (Vector2.create 0. 0.) 0. Color.white;
    (* bottom *)
    let src = rect il (th - ib) (tw - il - ir) ib in
    let dst = rect (x + il) (y + h - ib) (w - il - ir) ib in
    draw_texture_pro texture src dst (Vector2.create 0. 0.) 0. Color.white;
    (* bottom left *)
    let src = rect 0 (th - ib) il ib in
    let dst = rect x (y + h - ib) il ib in
    draw_texture_pro texture src dst (Vector2.create 0. 0.) 0. Color.white;
    (*  left *)
    let src = rect 0 it il (th - it - ib) in
    let dst = rect x (y + it) il (h - it - ib) in
    draw_texture_pro texture src dst (Vector2.create 0. 0.) 0. Color.white
;;
