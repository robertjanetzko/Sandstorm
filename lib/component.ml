module type Sig = sig
  type t

  val create : t -> Entity.id_t -> unit
  val set : t -> Entity.id_t -> unit
  val get : Entity.id_t -> t
  val get_opt : Entity.id_t -> t option
  val iter : (Entity.id_t -> t -> unit) -> unit
  val fold : (Entity.id_t -> t -> 'acc -> 'acc) -> 'acc -> 'acc
  val first : unit -> (Entity.id_t * t) option
  val is : Entity.id_t -> bool
  val remove : Entity.id_t -> unit
  val all : unit -> Entity.id_t Seq.t
end

let allComponents : (module Sig) list ref = ref []

let create (type s) () =
  let module Def = struct
    type t = s

    let data : (Entity.id_t, t) Hashtbl.t = Hashtbl.create 0
    let create cmp id = Hashtbl.replace data id cmp
    let set = create
    let get id = Hashtbl.find data id
    let get_opt id = Hashtbl.find_opt data id
    let iter fn = Hashtbl.iter (fun k v -> fn k v) data
    let fold fn acc = Hashtbl.fold fn data acc
    let remove id = Hashtbl.remove data id
    let all () = Hashtbl.to_seq_keys data

    let is id =
      match get_opt id with
      | Some _ -> true
      | _ -> false
    ;;

    let first () =
      let list = Hashtbl.to_seq data |> Seq.take 1 |> List.of_seq in
      List.nth_opt list 0
    ;;
  end
  in
  let m = (module Def : Sig with type t = s) in
  allComponents := (module Def) :: !allComponents;
  m
;;

let all (module C : Sig) = C.all ()
let iter fn s = Seq.iter fn s
let ( !? ) = all
let query (module C : Sig) (entities : Entity.id_t Seq.t) = Seq.filter C.is entities
let query2 (entities : Entity.id_t Seq.t) (module C : Sig) = Seq.filter C.is entities
let ( >? ) = query2
let ( >! ) = Seq.iter
