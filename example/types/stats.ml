type t =
  { mutable walk_speed_multiplier : float
  ; mutable fire_rate_multiplier : float
  ; mutable damage_multiplier : float
  ; mutable other_mutliplier : float
  }

let default : t =
  { walk_speed_multiplier = 1.
  ; fire_rate_multiplier = 1.
  ; damage_multiplier = 1.
  ; other_mutliplier = 1.
  }
;;

let empty : t =
  { walk_speed_multiplier = 0.
  ; fire_rate_multiplier = 0.
  ; damage_multiplier = 0.
  ; other_mutliplier = 0.
  }
;;

let combine s1 s2 =
  s1.walk_speed_multiplier <- s1.walk_speed_multiplier +. s2.walk_speed_multiplier;
  s1.fire_rate_multiplier <- s1.fire_rate_multiplier +. s2.fire_rate_multiplier;
  s1.damage_multiplier <- s1.damage_multiplier +. s2.damage_multiplier;
  s1.other_mutliplier <- s1.other_mutliplier +. s2.other_mutliplier
;;

let text s =
  Format.sprintf "Walk Speed: %.2f\n" s.walk_speed_multiplier
  ^ Format.sprintf "Fire Rate: %.2f\n" s.fire_rate_multiplier
  ^ Format.sprintf "Damage Mult: %.2f\n" s.damage_multiplier
  ^ Format.sprintf "Other: %.2f\n" s.other_mutliplier
;;
