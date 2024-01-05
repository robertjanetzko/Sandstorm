type t =
  { duration : float
  ; mutable value : float
  }

let delay duration = { duration; value = 0. }
let start duration = { duration; value = duration }

let step_mult multiplier t =
  t.value <- t.value +. Raylib.get_frame_time ();
  let duration = t.duration /. multiplier in
  if t.value >= duration
  then (
    t.value <- t.value -. duration;
    true)
  else false
;;

let step = step_mult 1.
