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
    ((module Collision_impact) ^? (module Pickup))
    (fun id impact amount ->
      impact.others
      |> query_iter
           (query (module Player.Tag))
           (fun id2 _player ->
             pickup amount id2;
             destroy_entity id))
;;

let level_up_system =
  System.for_each
    ((module Experience) ^& (module Level) ^? (module Player.Tag))
    (fun id amount level _input ->
      if !amount >= 100 * level
      then (
        Level.set (level + 1) id;
        Util.Ui.show_level_up ()))
;;
