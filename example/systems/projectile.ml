open Sandstorm
open Sandstorm_raylib_components
open Components

let cleanup_system =
  System.for_each
    ((module Collision_impact) ^? (module Projectile))
    (fun id _impact _c -> destroy_entity id)
;;
