open Engine

module C = struct
  type s = int ref

  include (val Component.create () : Component.Sig with type t = s)
end

let pickup amount entity =
  match C.get_opt entity with
  | Some exp -> exp := !exp + amount
  | _ -> ()
;;

module Pickup = struct
  module C = struct
    type s = int

    include (val Component.create () : Component.Sig with type t = s)
  end

  let system =
    System.create2
      (module C)
      (module Collision.Impact)
      (fun id amount impact ->
        pickup amount impact.other;
        destroy_entity id)
  ;;
end

let ui_system =
  System.create2
    (module C)
    (module PlayerInput.C)
    (fun _id amount _player ->
      let open Raylib in
      let w = get_render_width () in
      let h = get_render_height () in
      draw_rectangle 0 (h - 10) w 10 Color.gray;
      let exp_w = w * !amount / 1000 in
      draw_rectangle 0 (h - 10) exp_w 10 Color.darkblue;
      let msg = string_of_int !amount in
      let msg_w = Raylib.measure_text msg 10 in
      Raylib.draw_text msg ((w - msg_w) / 2) (h - 10) 10 Color.white)
;;
