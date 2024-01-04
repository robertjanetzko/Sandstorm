open Sandstorm
open Raylib

module Position = struct
  type s = Vector2.t

  include (val Component.create () : Component.Sig with type t = s)

  (*   let quadtree = Quadtree.create 1000.

       let refresh_quadtee () =
       Quadtree.clear quadtree;
       Seq.iter (fun id -> Quadtree.insert quadtree (get id) id) (all ())
       ;; *)
end

let nearest_position query pos =
  let t =
    Position.fold
      (fun entity_id entity_pos acc ->
        if query_matches entity_id query
        then (
          let dist = Vector2.distance pos entity_pos in
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

(* let position_index_system = System.base (fun _state -> Position.refresh_quadtee ())

   let position_index_debug_system =
   System.base (fun _state -> Quadtree.debug Position.quadtree)
   ;; *)

module Velocity = struct
  type s = Vector2.t

  include (val Component.create () : Component.Sig with type t = s)
end

let velocity_system =
  System.for_each
    Sandstorm.((module Velocity) ^? (module Position))
    (fun id v p ->
      let v = Vector2.scale v (get_frame_time ()) in
      Position.set (Vector2.add p v) id)
;;