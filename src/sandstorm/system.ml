module type GAMESTATE = sig
  type t
end

module Make (G : GAMESTATE) = struct
  module type Sig = sig
    type state_t

    val process : G.t -> unit
  end

  let has_all (cmps : (module Component.Sig) list) id =
    List.fold_left (fun a (module C : Component.Sig) -> a && C.is id) true cmps
  ;;

  let for_each query process =
    let module Def = struct
      type state_t = G.t

      let process _state = Query.for_each query process
    end
    in
    (module Def : Sig with type state_t = G.t)
  ;;

  let for_each_state query process =
    let module Def = struct
      type state_t = G.t

      let process state = Query.for_each query (process state)
    end
    in
    (module Def : Sig with type state_t = G.t)
  ;;

  let base (process : G.t -> unit) =
    let module Def = struct
      type state_t = G.t

      let process = process
    end
    in
    (module Def : Sig with type state_t = G.t)
  ;;

  let create_group ?(condition = fun _ -> true) systems =
    let module Def = struct
      type state_t = G.t

      let process state =
        if condition state
        then
          Array.iter
            (fun (module S : Sig with type state_t = G.t) -> S.process state)
            systems
      ;;
    end
    in
    (module Def : Sig with type state_t = G.t)
  ;;
end
