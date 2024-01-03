open Sandstorm
open Sandstorm.DefaultComponents
open Components
open Raylib

let would_collide id new_pos =
  let s = Component.(query (module Collision.Shape) >? (module Position)) in
  Seq.exists (fun id2 -> Collision.overlap ~new_p1:(Some new_pos) id id2) s
;;

let system =
  System.for_each
    ((module Position) ^& (module Mob.Tag) ^? (module Velocity))
    (fun id pos _c _v ->
      let direction =
        Vector2.subtract (Util.Utils.player_pos ()) pos |> Vector2.normalize
      in
      let velocity = Vector2.scale direction 50. in
      (* if not (would_collide id new_pos) then *)
      Velocity.set velocity id)
;;
