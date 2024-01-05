open Sandstorm
open Components.Health

let system =
  System.for_each
    (query (module Health))
    (fun id health -> if health.current <= 0. then Dead.set () id)
;;

let death_system =
  System.for_each (query (module Dead)) (fun id _dead -> destroy_entity id)
;;
