module Position = struct
  type s = Raylib.Vector2.t

  include (val Component.create () : Component.Sig with type t = s)

  let nearest filter pos =
    let t =
      fold
        (fun entity_id entity_pos acc ->
          if filter entity_id
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
end
