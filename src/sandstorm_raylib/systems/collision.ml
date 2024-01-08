open Sandstorm
open Sandstorm_raylib_components
open Raylib

let match_mask m1 m2 = m1 land m2 > 0

let overlap ?(new_p1 = None) id1 id2 =
  if id1 == id2
  then false
  else (
    let p1 =
      match new_p1 with
      | Some p -> p
      | None -> Position.get id1
    in
    let p2 = Position.get id2 in
    let s1 = Collision_shape.get id1 in
    let s2 = Collision_shape.get id2 in
    if not @@ match_mask s1.mask s2.mask
    then false
    else (
      match s1.shape, s2.shape with
      | Circle r1, Circle r2 -> Vector2.distance p1 p2 < r1 +. r2
      | _ -> false))
;;

let detect id1 id2 =
  if id1 != id2 && overlap id1 id2
  then (
    let s1 = Collision_shape.get id1 in
    let s2 = Collision_shape.get id2 in
    s1.new_overlapping_entities <- id2 :: s1.new_overlapping_entities;
    s2.new_overlapping_entities <- id1 :: s2.new_overlapping_entities)
;;

(* Collision_impact.set { other = id2; position = Position.get id1 } id1 *)

module IdSet = Set.Make (Int)

let update_overlaps id (shp : Collision_shape.s) =
  List.iter
    (fun id1 ->
      match List.find_opt (Int.equal id1) shp.overlapping_entities with
      | None ->
        (match Collision_impact.get_opt id1 with
         | Some impact ->
           Collision_impact.set { impact with others = id :: impact.others } id1
         | None ->
           Collision_impact.set { others = [ id ]; position = Position.get id1 } id1)
      | Some _ -> ())
    shp.new_overlapping_entities;
  shp.overlapping_entities <- shp.new_overlapping_entities
;;

let system =
  System.base (fun _state ->
    Collision_shape.sort_axis ();
    let active = ref IdSet.empty in
    !Collision_shape.sorted_list
    |> List.to_seq
    |> Seq.filter Collision_shape.is
    |> Seq.iter (fun id1 ->
      let shp = Collision_shape.get id1 in
      shp.new_overlapping_entities <- [];
      !active
      |> IdSet.iter (fun id2 ->
        if Collision_shape.min_x id1 > Collision_shape.max_x id2
        then active := IdSet.remove id2 !active
        else detect id1 id2);
      active := IdSet.add id1 !active);
    Collision_shape.iter update_overlaps)
;;

let cleanup_system =
  System.for_each
    (Sandstorm.query (module Collision_impact))
    (fun id _impact -> Collision_impact.remove id)
;;

let debug_system =
  System.for_each
    Sandstorm.((module Collision_shape) ^? (module Position))
    (fun _id shape pos ->
      match shape.shape with
      | Circle r ->
        draw_circle_lines
          (int_of_float @@ Vector2.x pos)
          (int_of_float @@ Vector2.y pos)
          r
          Color.yellow
      | Rect (w, h) -> draw_rectangle_v pos (Vector2.create w h) Color.yellow)
;;
