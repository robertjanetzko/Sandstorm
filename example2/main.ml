open Sandstorm

module GameState = struct
  type t = float ref
end

module S = BaseSystem.Make (GameState)

let simple =
  S.base (fun state ->
    state := !state +. 1.;
    print_endline @@ string_of_float !state)
;;

module SimpleWorld = struct
  type state_t = GameState.t

  let systems = [| simple |]
  let init () = ()
  let init_state () = ref 1.
  let should_stop state = !state > 100.
end

module Game = World.Make (SimpleWorld)

let () = Game.run ()
