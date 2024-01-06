open Sandstorm

module Counter = struct
  type s = float ref

  include (val Component.create () : Component.Sig with type t = s)
end

let simple =
  System.for_each
    (query (module Counter))
    (fun _id counter ->
      counter := !counter +. 1.;
      print_endline @@ string_of_float !counter)
;;

module SimpleWorld = struct
  let systems = [| simple |]
  let setup () = Entity.create [ Counter.create @@ ref 0. ]
  let cleanup () = ()

  let should_stop () =
    match Counter.first () with
    | Some (_, counter) -> !counter >= 10.
    | _ -> false
  ;;
end

module Game = World.Make (SimpleWorld)

let () = Game.run ()
