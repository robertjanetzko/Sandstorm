open Engine
open DefaultComponents
open Raylib

module AnimationController = struct
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
  let ctrl = AnimationController.create { animations; current } in
  List.iter
    (fun (name, (from_index, to_index)) ->
      Hashtbl.add animations name { from_index; to_index })
    animation_list;
  ctrl
;;

let system =
  System.for_each
    ((module AnimationController) ^? (module SpriteRenderer.Animator))
    (fun id ctrl anim ->
      let next_anim =
        match Velocity.get_opt id with
        | Some v when Vector2.length v > 0. -> "walk"
        | _ -> "idle"
      in
      ctrl.current <- next_anim;
      anim.animation <- Hashtbl.find ctrl.animations ctrl.current)
;;
