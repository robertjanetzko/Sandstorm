open Engine

module C = struct
  type s = int ref

  include (val Component.create () : Component.Sig with type t = s)
end

let pickup amount entity =
  match C.get_opt entity with
  | Some exp -> exp := !exp + amount
  | _ -> ()
;;

module Pickup = struct
  module C = struct
    type s = int

    include (val Component.create () : Component.Sig with type t = s)
  end

  module S = struct
    let process id amount (impact : Collision.Impact.t) =
      pickup amount impact.other;
      destroy_entity id
    ;;

    include (val System.create2 process (module C) (module Collision.Impact))
  end
end
