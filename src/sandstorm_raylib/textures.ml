open Raylib

let textures = Hashtbl.create 100

let get name =
  match Hashtbl.find_opt textures name with
  | Some t -> t
  | _ ->
    let t = load_texture name in
    Hashtbl.add textures name t;
    t
;;

let cleanup () = Hashtbl.iter (fun _name texture -> unload_texture texture) textures
