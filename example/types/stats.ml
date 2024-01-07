type t =
  { mutable health : float
  ; mutable health_maximum : float
  ; mutable walk_speed_multiplier : float
  ; mutable fire_rate_multiplier : float
  ; mutable damage_multiplier : float
  }

let default () : t =
  { walk_speed_multiplier = 1.
  ; fire_rate_multiplier = 1.
  ; damage_multiplier = 1.
  ; health = 100.
  ; health_maximum = 100.
  }
;;

let empty () : t =
  { health = 0.
  ; health_maximum = 0.
  ; walk_speed_multiplier = 0.
  ; fire_rate_multiplier = 0.
  ; damage_multiplier = 0.
  }
;;

let combine s1 s2 =
  s1.health <- s1.health +. s2.health;
  s1.health_maximum <- s1.health_maximum +. s2.health_maximum;
  s1.walk_speed_multiplier <- s1.walk_speed_multiplier +. s2.walk_speed_multiplier;
  s1.fire_rate_multiplier <- s1.fire_rate_multiplier +. s2.fire_rate_multiplier;
  s1.damage_multiplier <- s1.damage_multiplier +. s2.damage_multiplier
;;

let text s =
  Format.sprintf "Walk Speed: %.2f\n" s.walk_speed_multiplier
  ^ Format.sprintf "Fire Rate: %.2f\n" s.fire_rate_multiplier
  ^ Format.sprintf "Damage Mult: %.2f\n" s.damage_multiplier
;;
