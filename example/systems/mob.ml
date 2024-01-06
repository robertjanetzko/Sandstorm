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
    ((module Position) ^& (module Dead) ^? (module Mob.Tag))
    (fun _id pos _dead _mob ->
      Util.Game.spawn_experience_pickup pos;
      Util.Game.spawn_death_effect pos)
;;

let health_bar_system =
  System.for_each
    ((module Mob.Tag) ^& (module Stats) ^? (module Position))
    (fun _id _mob stats pos ->
      let msg = Format.sprintf "%.0f/%.0f" stats.health stats.health_maximum in
      let x = int_of_float @@ Vector2.x pos in
      let y = (int_of_float @@ Vector2.y pos) - 30 in
      draw_text msg x y 10 Color.white)
;;
