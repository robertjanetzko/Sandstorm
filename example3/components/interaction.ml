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

  let step ?(max = 1.) ?(decay = 0.) ~completion id =
    let progress =
      let incr = (decay +. 1.) *. Raylib.get_frame_time () in
      match get_opt id with
      | Some progress -> { progress with value = progress.value +. incr }
      | None -> { value = incr; max; decay; completion }
    in
    set progress id;
    if progress.value >= progress.max then completion id
  ;;

  let decay id progress =
    let progress =
      { progress with
        value = max 0. (progress.value -. (progress.decay *. Raylib.get_frame_time ()))
      }
    in
    if progress.value <= 0. then remove id else set progress id
  ;;
end
