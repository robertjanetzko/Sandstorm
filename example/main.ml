open Sandstorm
open Sandstorm_raylib
open Sandstorm_raylib_systems
open Systems

module VampireWorld = struct
  let no_menu () = Option.is_none @@ Components.Ui.Menu.first ()
  (* let player_alive _state = Option.is_some @@ PlayerInput.C.first () *)
  (* let run_game state = player_alive state && no_menu state *)

  let game_systems =
    [| System.create_group
         ~condition:no_menu
         [| (* position_index_system *)
            Collision.system
          ; Damage.impact_damage_system
          ; Damage.mob_damage_system
          ; Player.system
          ; Shooter.system
          ; Experience.pickup_system
          ; Experience.level_up_system
          ; Mob.chase_player_system
          ; Health.system
          ; Mob.mob_killed_system
          ; Player.player_died_system
          ; Health.death_system
          ; Projectile.system
          ; Collision.cleanup_system
          ; Spawner.system
          ; Velocity.velocity_system
          ; Flip_sprite.flip_sprite_system
          ; Animation_controller.system
          ; Animation.animation_system
         |]
    |]
  ;;

  let render_systems =
    [| Sprite_renderer.system
     ; Shape_renderer.system
     ; Mob.health_bar_system
     ; Collision.debug_system
    |]
  ;;

  let ui_systems = [| Systems.Ui.group |]

  let setup () =
    Raylib.set_music_volume (Music_streams.get "resources/mini1111.xm") 0.3;
    (* Raylib.play_music_stream @@ Music_streams.get "resources/mini1111.xm"; *)
    Util.Game.start ()
  ;;

  let cleanup () = ()
end

module Game = World.Make (VampireWorld)

let () = Game.run ()
