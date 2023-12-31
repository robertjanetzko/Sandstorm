open Raylib

module Position = struct
  type s = Vector2.t

  include (val Component.create () : Component.Sig with type t = s)

  let nearest filter pos =
    let t =
      fold
        (fun entity_id entity_pos acc ->
          if filter entity_id
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
end

module Velocity = struct
  type s = Vector2.t

  include (val Component.create () : Component.Sig with type t = s)
end

let velocity_system =
  System.create_q2
    (Query.query2 (module Velocity) (module Position))
    (fun id v p ->
      let v = Vector2.scale v (get_frame_time ()) in
      Position.set (Vector2.add p v) id)
;;
