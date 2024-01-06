open Raylib

let music_streams = Hashtbl.create 100

let get name =
  match Hashtbl.find_opt music_streams name with
  | Some t -> t
  | _ ->
    let t = load_music_stream name in
    Hashtbl.add music_streams name t;
    t
;;

let update_all () =
  Hashtbl.iter (fun _name music -> update_music_stream music) music_streams
;;

let cleanup () = Hashtbl.iter (fun _name music -> unload_music_stream music) music_streams
