open Sandstorm
open Raylib
open Default_components

type collisionShape =
  | Circle of float
  | Rect of float * float

module Shape = struct
  type s =
    { shape : collisionShape
    ; mask : int
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
end

module Impact = struct
  type s =
    { other : Entity.id_t
    ; position : Vector2.t
    }

  include (val Component.create () : Component.Sig with type t = s)
end

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
    let s1 = Shape.get id1 in
    let s2 = Shape.get id2 in
    if not @@ match_mask s1.mask s2.mask
    then false
    else (
      match s1.shape, s2.shape with
      | Circle r1, Circle r2 -> Vector2.distance p1 p2 < r1 +. r2
      | _ -> false))
;;

let detect id1 id2 =
  if id1 != id2 && overlap id1 id2
  then Impact.set { other = id2; position = Position.get id1 } id1
;;

(* let system =
   System.create2
   (module Shape)
   (module Position)
   (fun id _s1 p1 ->
   let s =
   Quadtree.query ~center:p1 ~radius:30. Position.quadtree
   |> List.to_seq
   |> Seq.filter Shape.is
   in
   (* let s = Component.(query (module Shape) >? (module Position)) in *)
   Seq.iter (detect id) s)
   ;; *)

module IdSet = Set.Make (Int)

let system =
  System.base (fun _state ->
    Shape.sort_axis ();
    let active = ref IdSet.empty in
    !Shape.sorted_list
    |> List.to_seq
    |> Seq.filter Shape.is
    |> Seq.iter (fun id1 ->
      !active
      |> IdSet.iter (fun id2 ->
        if Shape.min_x id1 > Shape.max_x id2
        then active := IdSet.remove id2 !active
        else detect id1 id2);
      active := IdSet.add id1 !active))
;;

let cleanup_system =
  System.for_each (Sandstorm.query (module Impact)) (fun id _impact -> Impact.remove id)
;;
