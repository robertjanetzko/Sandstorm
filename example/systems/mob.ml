open Raylib
open Sandstorm
open Sandstorm_raylib_components
open Components

let chase_player_system =
  System.for_each
    ((module Position) ^& (module Mob.Tag) ^? (module Velocity))
    (fun id pos _c _v ->
      let direction =
        Vector2.subtract (Util.Player.player_pos ()) pos |> Vector2.normalize
      in
      let velocity = Vector2.scale direction 50. in
      Velocity.set velocity id)
;;

let mob_killed_system =
  System.for_each
    ((module Position) ^& (module Health.Dead) ^? (module Mob.Tag))
    (fun _id pos _dead _mob ->
      Util.Game.spawn_experience_pickup pos;
      Util.Game.spawn_death_effect pos)
;;
