open Sandstorm
open Components

let system =
  System.for_each
    (query (module Stats))
    (fun id stats -> if stats.health <= 0. then Dead.set () id)
;;

let death_system =
  System.for_each (query (module Dead)) (fun id _dead -> destroy_entity id)
;;
