module type Sig = sig
  val process : Game.state_t -> unit
end

let create1
  (type a)
  (process : Entity.id_t -> a -> unit)
  (module C : Component.Sig with type t = a)
  =
  let module Def = struct
    let process _state = C.iter process
  end
  in
  (module Def : Sig)
;;

let create2
  (type a b)
  (process : Entity.id_t -> a -> b -> unit)
  (module C : Component.Sig with type t = a)
  (module C2 : Component.Sig with type t = b)
  =
  let module Def = struct
    let process _state =
      C.iter (fun id av ->
        match C2.get id with
        | Some bv -> process id av bv
        | None -> ())
    ;;
  end
  in
  (module Def : Sig)
;;

let create2_w
  (type a b)
  (process : Game.state_t -> Entity.id_t -> a -> b -> unit)
  (module C : Component.Sig with type t = a)
  (module C2 : Component.Sig with type t = b)
  =
  let module Def = struct
    let process state =
      C.iter (fun id av ->
        match C2.get id with
        | Some bv -> process state id av bv
        | None -> ())
    ;;
  end
  in
  (module Def : Sig)
;;
