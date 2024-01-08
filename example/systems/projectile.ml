open Sandstorm
open Sandstorm_raylib_components
open Components

let impact_system =
  System.for_each
    ((module Collision_impact) ^? (module Projectile))
    (fun id impact projectile ->
      impact.others
      |> query_iter
           (query (module Mob.Tag))
           (fun _id2 _mob ->
             projectile.piercing <- projectile.piercing - 1;
             if projectile.piercing <= 0 then destroy_entity id))
;;

let lifetime_system =
  System.for_each
    (query (module Projectile))
    (fun id projectile ->
      if Sandstorm_raylib.Timer.step projectile.lifetime then destroy_entity id)
;;

let system = System.create_group [| lifetime_system; impact_system |]
