module type Sig = sig
  val process : unit -> unit
end

(* let has_all (cmps : (module Component.Sig) list) id =
   List.fold_left (fun a (module C : Component.Sig) -> a && C.is id) true cmps
   ;; *)

let for_each query process =
  let module Def = struct
    let process _state = Query.for_each query process
  end
  in
  (module Def : Sig)
;;

(* let for_each_state query process =
   let module Def = struct
   type state_t = G.t

   let process state = Query.for_each query (process state)
   end
   in
   (module Def : Sig)
   ;; *)

let base (process : unit -> unit) =
  let module Def = struct
    let process = process
  end
  in
  (module Def : Sig)
;;

let create_group ?(condition = fun _ -> true) systems =
  let module Def = struct
    let process () =
      if condition () then Array.iter (fun (module S : Sig) -> S.process ()) systems
    ;;
  end
  in
  (module Def : Sig)
;;
