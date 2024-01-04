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
  then Collision_impact.set { other = id2; position = Position.get id1 } id1
;;

module IdSet = Set.Make (Int)

let system =
  System.base (fun _state ->
    Collision_shape.sort_axis ();
    let active = ref IdSet.empty in
    !Collision_shape.sorted_list
    |> List.to_seq
    |> Seq.filter Collision_shape.is
    |> Seq.iter (fun id1 ->
      !active
      |> IdSet.iter (fun id2 ->
        if Collision_shape.min_x id1 > Collision_shape.max_x id2
        then active := IdSet.remove id2 !active
        else detect id1 id2);
      active := IdSet.add id1 !active))
;;

let cleanup_system =
  System.for_each
    (Sandstorm.query (module Collision_impact))
    (fun id _impact -> Collision_impact.remove id)
;;
