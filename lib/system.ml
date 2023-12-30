module type Sig = sig
  val process : Game.state_t -> unit
end

let create
  (type a)
  (module C : Component.Sig with type t = a)
  (process : Entity.id_t -> a -> unit)
  =
  let module Def = struct
    let process _state = C.iter process
  end
  in
  (module Def : Sig)
;;

let create2
  (type a b)
  (module C : Component.Sig with type t = a)
  (module C2 : Component.Sig with type t = b)
  (process : Entity.id_t -> a -> b -> unit)
  =
  let module Def = struct
    let process _state =
      C.iter (fun id av ->
        match C2.get_opt id with
        | Some bv -> process id av bv
        | None -> ())
    ;;
  end
  in
  (module Def : Sig)
;;

let create3
  (type a b c)
  (module C : Component.Sig with type t = a)
  (module C2 : Component.Sig with type t = b)
  (module C3 : Component.Sig with type t = c)
  (process : Entity.id_t -> a -> b -> c -> unit)
  =
  let module Def = struct
    let process _state =
      let pr (id : Entity.id_t) = process id (C.get id) (C2.get id) (C3.get id) in
      let seq = Component.(!?(module C) >? (module C2) >? (module C3)) in
      Seq.iter pr seq
    ;;
  end
  in
  (module Def : Sig)
;;

let create2w
  (type a b)
  (module C : Component.Sig with type t = a)
  (module C2 : Component.Sig with type t = b)
  (process : Game.state_t -> Entity.id_t -> a -> b -> unit)
  =
  let module Def = struct
    let process state =
      C.iter (fun id av ->
        match C2.get_opt id with
        | Some bv -> process state id av bv
        | None -> ())
    ;;
  end
  in
  (module Def : Sig)
;;
