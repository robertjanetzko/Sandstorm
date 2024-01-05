open Sandstorm
open Sandstorm_raylib
open Sandstorm_raylib_components
open Components
open Components.Experience
open Raylib

let pickup amount entity =
  play_sound @@ Sounds.get "resources/coin.wav";
  match Experience.get_opt entity with
  | Some exp -> exp := !exp + amount
  | _ -> ()
;;

let pickup_system =
  System.for_each
    ((module Pickup) ^? (module Collision_impact))
    (fun id amount impact ->
      pickup amount impact.other;
      destroy_entity id)
;;

let level_up_system =
  System.for_each
    ((module Experience) ^& (module Level) ^? (module Player.Tag))
    (fun id amount level _input ->
      if !amount >= 1000 * level
      then (
        Level.set (level + 1) id;
        Util.Ui.show_level_up ()))
;;
