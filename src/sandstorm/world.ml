module type WORLD = sig
  val systems : (module System.Sig) array
  val setup : unit -> unit
  val should_stop : unit -> bool
  val cleanup : unit -> unit
end

module Make (W : WORLD) = struct
  let rec loop () =
    match W.should_stop () with
    | true -> ()
    | false ->
      Array.iter (fun (module S : System.Sig) -> S.process ()) W.systems;
      loop ()
  ;;

  let run () =
    W.setup ();
    loop ();
    W.cleanup ()
  ;;
end
