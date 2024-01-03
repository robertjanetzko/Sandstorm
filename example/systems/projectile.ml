open Sandstorm
open Components

let cleanup_system =
  System.for_each
    ((module Collision.Impact) ^? (module Projectile))
    (fun id _impact _c -> destroy_entity id)
;;
