module type Sig = sig
  val process : Game.state_t -> unit
end

let has_all (cmps : (module Component.Sig) list) id =
  List.fold_left (fun a (module C : Component.Sig) -> a && C.is id) true cmps
;;

let for_each query process =
  let module Def = struct
    let process _state = Qq.for_each query process
  end
  in
  (module Def : Sig)
;;

let for_each_state query process =
  let module Def = struct
    let process state = Qq.for_each query (process state)
  end
  in
  (module Def : Sig)
;;

let base (process : Game.state_t -> unit) =
  let module Def = struct
    let process = process
  end
  in
  (module Def : Sig)
;;

let create_group ?(condition = fun _ -> true) systems =
  let module Def = struct
    let process state =
      if condition state then Array.iter (fun (module S : Sig) -> S.process state) systems
    ;;
  end
  in
  (module Def : Sig)
;;
