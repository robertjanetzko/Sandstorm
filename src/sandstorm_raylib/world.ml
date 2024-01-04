open Raylib

module type WORLD = sig
  val game_systems : (module System.Sig) array
  val render_systems : (module System.Sig) array
  val ui_systems : (module System.Sig) array
  val init : unit -> unit
end

module RMake =
functor
  (W : WORLD)
  ->
  struct
    module R = struct
      type state_t = Game.t

      let systems = [||]

      let init () =
        init_window 800 600 "raylib [core] example - mouse input";
        set_window_position 0 0;
        set_window_state [ ConfigFlags.Window_resizable ];
        (* set_target_fps 60; *)
        W.init ()
      ;;

      let init_state : unit -> state_t =
        fun () ->
        let default_camera =
          let open Raylib in
          Camera2D.create
            (Vector2.create (Float.of_int 800 /. 2.0) (Float.of_int 600 /. 2.0))
            (Vector2.zero ())
            0.0
            1.0
        in
        { camera = default_camera }
      ;;
    end

    include Sandstorm.World.Make (R)

    (* let state : Game.t =
      let default_camera =
        let open Raylib in
        Camera2D.create
          (Vector2.create (Float.of_int 800 /. 2.0) (Float.of_int 600 /. 2.0))
          (Vector2.zero ())
          0.0
          1.0
      in
      { camera = default_camera }
    ;;*)

    let process_systems systems =
      Array.iter (fun (module S : System.Sig) -> S.process state) systems
    ;;

    let rec loop () =
      match window_should_close () with
      | true -> close_window ()
      | false ->
        Camera2D.set_offset
          state.camera
          (Vector2.create
             (Float.of_int (get_render_width ()) /. 2.0)
             (Float.of_int (get_render_height ()) /. 2.0));
        process_systems W.game_systems;
        begin_drawing ();
        clear_background Color.darkgreen;
        draw_fps 10 10;
        begin_mode_2d state.camera;
        process_systems W.render_systems;
        end_mode_2d ();
        process_systems W.ui_systems;
        end_drawing ();
        loop ()
    ;;

    let run () =
      setup ();
      loop ()
    ;;
  end
(*
   module Make =
functor
  (W : WORLD)
  ->
  struct
    let setup () =
      init_window 800 600 "raylib [core] example - mouse input";
      set_window_position 0 0;
      set_window_state [ ConfigFlags.Window_resizable ];
      (* set_target_fps 60; *)
      W.init ()
    ;;

    let default_camera =
      let open Raylib in
      Camera2D.create
        (Vector2.create (Float.of_int 800 /. 2.0) (Float.of_int 600 /. 2.0))
        (Vector2.zero ())
        0.0
        1.0
    ;;

    let state : Game.t = { camera = default_camera }

    let process_systems systems =
      Array.iter (fun (module S : System.Sig) -> S.process state) systems
    ;;

    let rec loop () =
      match window_should_close () with
      | true -> close_window ()
      | false ->
        Camera2D.set_offset
          state.camera
          (Vector2.create
             (Float.of_int (get_render_width ()) /. 2.0)
             (Float.of_int (get_render_height ()) /. 2.0));
        process_systems W.game_systems;
        begin_drawing ();
        clear_background Color.darkgreen;
        draw_fps 10 10;
        begin_mode_2d state.camera;
        process_systems W.render_systems;
        end_mode_2d ();
        process_systems W.ui_systems;
        end_drawing ();
        loop ()
    ;;

    let run () =
      setup ();
      loop ()
    ;;
  end *)
