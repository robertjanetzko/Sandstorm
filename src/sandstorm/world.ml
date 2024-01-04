module type WORLD = sig
  val systems : (module System.Sig) array
  val setup : unit -> unit
  val should_stop : unit -> bool
end

module Make =
functor
  (W : WORLD)
  ->
  struct
    let setup () = W.setup ()

    let process_systems systems =
      Array.iter (fun (module S : System.Sig) -> S.process ()) systems
    ;;

    let rec loop () =
      match W.should_stop () with
      | true -> ()
      | false ->
        process_systems W.systems;
        loop ()
    ;;

    let run () =
      setup ();
      loop ()
    ;;
  end
