open Sandstorm

let reset () =
  MobSpawner.MobTag.all () |> Seq.iter destroy_entity;
  Projectile.C.all () |> Seq.iter destroy_entity;
  Experience.Pickup.C.all () |> Seq.iter destroy_entity;
  Player.create ()
;;
