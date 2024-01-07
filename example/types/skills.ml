type t =
  { name : string
  ; stats : Stats.t
  }

let skills =
  [| { name = "More Speed"
     ; stats = { (Stats.empty ()) with walk_speed_multiplier = 0.05 }
     }
   ; { name = "Even more Speed"
     ; stats = { (Stats.empty ()) with walk_speed_multiplier = 1. }
     }
   ; { name = "More Firerate"
     ; stats = { (Stats.empty ()) with fire_rate_multiplier = 0.05 }
     }
   ; { name = "Even more Firerate"
     ; stats = { (Stats.empty ()) with fire_rate_multiplier = 1. }
     }
   ; { name = "More Damage"; stats = { (Stats.empty ()) with damage_multiplier = 0.05 } }
   ; { name = "More HP"
     ; stats = { (Stats.empty ()) with health = 10.; health_maximum = 10. }
     }
  |]
;;

let random_skill () = Random.int @@ Array.length skills
