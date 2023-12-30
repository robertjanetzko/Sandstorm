type t =
  { duration : float
  ; mutable value : float
  }

let create duration = { duration; value = duration }

let step t =
  t.value <- t.value -. Raylib.get_frame_time ();
  if t.value <= 0.
  then (
    t.value <- t.value +. t.duration;
    true)
  else false
;;
