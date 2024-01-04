module type SYSTEM = sig
  type state_t

  val process : state_t -> unit
end

module type WORLD = sig
  type state_t

  val systems : (module SYSTEM with type state_t = state_t) array
  val init : unit -> unit
  val init_state : unit -> state_t
end

module Make =
functor
  (W : WORLD)
  ->
  struct
    let setup () = W.init ()
    let state = W.init_state ()

    let process_systems systems =
      Array.iter
        (fun (module S : SYSTEM with type state_t = W.state_t) -> S.process state)
        systems
    ;;

    let rec loop () =
      process_systems W.systems;
      loop ()
    ;;

    let run () =
      setup ();
      loop ()
    ;;
  end
