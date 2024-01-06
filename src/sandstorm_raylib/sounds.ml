open Raylib

let sounds = Hashtbl.create 100

let get name =
  match Hashtbl.find_opt sounds name with
  | Some t -> t
  | _ ->
    let t = load_sound name in
    Hashtbl.add sounds name t;
    t
;;

let cleanup () = Hashtbl.iter (fun _name sound -> unload_sound sound) sounds
