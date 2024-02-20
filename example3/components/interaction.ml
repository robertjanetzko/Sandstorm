open Sandstorm

type s =
  { range : float
  ; action : Entity.id_t -> unit
  ; single : bool
  }

include (val Component.create () : Component.Sig with type t = s)
module Active = Component.MakeTag ()

module Progress = struct
  type s =
    { value : float
    ; max : float
    ; decay : float
    ; completion : Entity.id_t -> unit
    }

  include (val Component.create () : Component.Sig with type t = s)
end

let progress ?(max = 1.) ?(decay = 0.) ~completion id =
  let progress =
    let incr = (decay +. 1.) *. Raylib.get_frame_time () in
    match Progress.get_opt id with
    | Some progress -> { progress with value = progress.value +. incr }
    | None -> { value = incr; max; decay; completion }
  in
  Progress.set progress id;
  if progress.value >= progress.max then completion id
;;
