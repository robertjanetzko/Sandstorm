open Sandstorm
open Sandstorm_raylib
open Sandstorm_raylib_systems

module SurvivalWorld = struct
  let no_menu () = true

  let game_systems =
    [| System.create_group
         ~condition:no_menu
         [| Collision.system
          ; Survival_systems.Player.system
          ; Survival_systems.Interaction.system
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
     ; Survival_systems.Interaction.ui_system
    |]
  ;;

  let ui_systems = [||]
  let setup () = Survival_util.Game.start ()
  let cleanup () = ()
end

module Game = World.Make (SurvivalWorld)

let () = Game.run ()
