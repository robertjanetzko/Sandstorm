open Sandstorm
open Sandstorm_raylib
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
          ; Health.system
          ; MobKilled.mob_killed_system
          ; Player.player_died_system
          ; Health.death_system
          ; Projectile.cleanup_system
          ; Collision.cleanup_system
          ; Spawner.system
          ; MobFollow.system
          ; velocity_system
          ; SpriteRenderer.flip_sprite_system
          ; Animation.system
          ; SpriteRenderer.animation_system
         |]
    |]
  ;;

  let render_systems =
    [| SpriteRenderer.system; ShapeRenderer.system (*; position_index_debug_system*) |]
  ;;

  let ui_systems =
    [| Health.ui_system
     ; Experience.ui_system
     ; Systems.Ui.level_up_ui_system
     ; Systems.Ui.game_over_ui_system
    |]
  ;;

  let setup () =
    Util.GameUtil.create_player ();
    Spawner.create 0.3
  ;;
end

module Game = World.Make (VampireWorld)

let () = Game.run ()
