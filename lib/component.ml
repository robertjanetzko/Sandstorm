module type Sig = sig
  type t

  val create : t -> Entity.id_t -> unit
  val set : t -> Entity.id_t -> unit
  val get : Entity.id_t -> t option
  val iter : (Entity.id_t -> t -> unit) -> unit
  val first : unit -> (Entity.id_t * t) option
end

let create (type s) () =
  let module Def = struct
    type t = s

    let data : (Entity.id_t, t) Hashtbl.t = Hashtbl.create 0
    let create cmp id = Hashtbl.replace data id cmp
    let set = create
    let get id = Hashtbl.find_opt data id
    let iter f = Hashtbl.iter (fun k v -> f k v) data

    let first () =
      let list = Hashtbl.to_seq data |> Seq.take 1 |> List.of_seq in
      List.nth_opt list 0
    ;;
  end
  in
  (module Def : Sig with type t = s)
;;
