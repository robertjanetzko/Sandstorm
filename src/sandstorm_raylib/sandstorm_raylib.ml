module World = World
open Sandstorm
open Sandstorm_raylib_components
open Sandstorm_raylib_types

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
