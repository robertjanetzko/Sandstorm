open Engine

module C = struct
  type s =
    { mutable current : float
    ; mutable max : float
    }

  include (val Component.create () : Component.Sig with type t = s)
end

module Dead = struct
  type s = unit

  include (val Component.create () : Component.Sig with type t = s)
end

let system =
  System.create (module C) (fun id health -> if health.current <= 0. then Dead.set () id)
;;

let death_system = System.create (module Dead) (fun id _dead -> destroy_entity id)

let ui_system =
  System.create_q
    (query (module C) >& (module PlayerInput.C))
    (fun _id health ->
      let open Raylib in
      let w = get_render_width () in
      let h = get_render_height () in
      draw_rectangle 0 (h - 20) w 10 Color.gray;
      let exp_w = int_of_float (float_of_int w *. health.current /. health.max) in
      draw_rectangle 0 (h - 20) exp_w 10 Color.red;
      let msg = string_of_float health.current in
      let msg_w = Raylib.measure_text msg 10 in
      Raylib.draw_text msg ((w - msg_w) / 2) (h - 20) 10 Color.white)
;;
