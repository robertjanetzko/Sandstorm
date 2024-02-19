module Component = Component
module Entity = Entity
module System = System
module World = World
module ListUtil = Util

(* let query = Query.query
   let query2 = Query.query2
   let ( >& ) = Query.( >& )
   let ( >&& ) = Query.( >&& ) *)

type 'a comp = 'a Query.comp
type 'a query = 'a Query.query

let query_eval = Query.eval
let query_matches = Query.is
let query_each = Query.for_each
let query_first = Query.first
let query_iter = Query.iter
let query = Query.query
let ( ^& ) = Query.( ^& )
let ( ^? ) = Query.( ^? )

let destroy_entity id =
  let modules = !Component.allComponents in
  List.iter (fun (module M : Component.Sig) -> M.remove id) modules
;;

let destroy_all_entities () =
  let modules = !Component.allComponents in
  List.iter
    (fun (module M : Component.Sig) -> M.iter (fun id _ -> destroy_entity id))
    modules
;;
