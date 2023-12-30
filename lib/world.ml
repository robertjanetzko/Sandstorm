open Raylib

module type WORLD = sig
  val systems : (module System.Sig) array
  val ui_systems : (module System.Sig) array
  val init : unit -> unit
end

module Make =
functor
  (W : WORLD)
  ->
  struct
    let setup () =
      init_window 800 600 "raylib [core] example - mouse input";
      set_window_position 0 0;
      set_target_fps 60;
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

    let state : Game.state_t = { camera = default_camera }

    let process_systems systems =
      Array.iter (fun (module S : System.Sig) -> S.process state) systems
    ;;

    let rec loop () =
      match window_should_close () with
      | true -> close_window ()
      | false ->
        begin_drawing ();
        clear_background Color.black;
        draw_fps 10 10;
        begin_mode_2d state.camera;
        process_systems W.systems;
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
