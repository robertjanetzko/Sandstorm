module type WORLD = sig
  val systems : (module System.Sig) array
  val init : unit -> unit
end

module Make =
functor
  (W : WORLD)
  ->
  struct
    let setup () =
      Raylib.init_window 800 600 "raylib [core] example - mouse input";
      Raylib.set_window_position 0 0;
      (* Raylib.set_target_fps 120; *)
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

    let process_systems state =
      Array.iter (fun (module S : System.Sig) -> S.process state) W.systems
    ;;

    let rec loop () =
      match Raylib.window_should_close () with
      | true -> Raylib.close_window ()
      | false ->
        Raylib.begin_drawing ();
        Raylib.clear_background Raylib.Color.black;
        Raylib.draw_fps 10 10;
        Raylib.begin_mode_2d state.camera;
        process_systems state;
        Raylib.end_mode_2d ();
        Raylib.end_drawing ();
        loop ()
    ;;

    let run () =
      setup ();
      loop ()
    ;;
  end
