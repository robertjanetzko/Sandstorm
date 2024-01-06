open Sandstorm
open Sandstorm_raylib_components
open Raylib

module type WORLD = sig
  val game_systems : (module System.Sig) array
  val render_systems : (module System.Sig) array
  val ui_systems : (module System.Sig) array
  val setup : unit -> unit
  val cleanup : unit -> unit
end

module Make (W : WORLD) = struct
  module R = struct
    let camera =
      let open Raylib in
      Camera2D.create (Vector2.zero ()) (Vector2.zero ()) 0.0 1.0
    ;;

    let update_camera () =
      query_each
        ((module Position) ^? (module Follow_camera))
        (fun _id pos _cam -> Camera2D.set_target camera pos)
    ;;

    let setup () =
      init_window 800 600 "raylib [core] example - mouse input";
      init_audio_device ();
      set_master_volume 1.;
      set_window_position 0 0;
      set_window_state [ ConfigFlags.Window_resizable ];
      set_target_fps 60;
      W.setup ()
    ;;

    let should_stop _state = window_should_close ()

    let runner =
      System.base (fun state ->
        Music_streams.update_all ();
        Camera2D.set_offset camera (Vector2.scale (Window.size ()) 0.5);
        let process_systems systems =
          Array.iter (fun (module S : System.Sig) -> S.process state) systems
        in
        process_systems W.game_systems;
        begin_drawing ();
        clear_background Color.darkgreen;
        draw_fps 10 10;
        update_camera ();
        begin_mode_2d camera;
        process_systems W.render_systems;
        end_mode_2d ();
        process_systems W.ui_systems;
        end_drawing ())
    ;;

    let systems = [| runner |]

    let cleanup () =
      W.cleanup ();
      Textures.cleanup ();
      Sounds.cleanup ();
      Music_streams.cleanup ();
      close_audio_device ();
      close_window ()
    ;;
  end

  include Sandstorm.World.Make (R)
end
