open Engine
open Engine.DefaultComponents

module VampireWorld = struct
  let no_menu _state = Option.is_none @@ Menu.C.first ()
  (* let player_alive _state = Option.is_some @@ PlayerInput.C.first () *)
  (* let run_game state = player_alive state && no_menu state *)

  let systems =
    [| System.create_group
         ~condition:no_menu
         [| (* position_index_system *)
            Collision.system
          ; Damage.impact_damage_system
          ; Damage.mob_damage_system
          ; PlayerInput.system
          ; Shooter.system
          ; Experience.Pickup.system
          ; Experience.level_up_system
          ; Health.system
          ; MobSpawner.mob_killed_system
          ; Player.player_died_system
          ; Health.death_system
          ; Projectile.cleanup_system
          ; Collision.cleanup_system
          ; MobSpawner.system
          ; Follow.system
          ; velocity_system
          ; SpriteRenderer.flip_sprite_system
          ; Animations.system
          ; SpriteRenderer.animation_system
         |]
     ; FollowCamera.system
    |]
  ;;

  let render_systems =
    [| SpriteRenderer.system; ShapeRenderer.system (*; position_index_debug_system*) |]
  ;;

  let ui_systems =
    [| Health.ui_system
     ; Experience.ui_system
     ; Ui.level_up_ui_system
     ; Ui.game_over_ui_system
    |]
  ;;

  let init () =
    Player.create ();
    MobSpawner.create 0.3
  ;;
end

module Game = World.Make (VampireWorld)

let () = Game.run ()
