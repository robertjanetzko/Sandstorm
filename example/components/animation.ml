open Sandstorm

module Controller = struct
  type s =
    { animations : (string, SpriteRenderer.animation_t) Hashtbl.t
    ; mutable current : string
    }

  include (val Component.create () : Component.Sig with type t = s)
end

let create_controller (animation_list : (string * (int * int)) list) =
  let animations = Hashtbl.create @@ List.length animation_list in
  let current =
    match List.nth animation_list 0 with
    | name, _ -> name
  in
  let ctrl = Controller.create { animations; current } in
  List.iter
    (fun (name, (from_index, to_index)) ->
      Hashtbl.add animations name { from_index; to_index })
    animation_list;
  ctrl
;;
