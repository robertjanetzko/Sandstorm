module Component = Component
module Entity = Entity
module BaseSystem = System
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
let query = Query.query
let ( ^& ) = Query.( ^& )
let ( ^? ) = Query.( ^? )

let destroy_entity id =
  let modules = !Component.allComponents in
  List.iter (fun (module M : Component.Sig) -> M.remove id) modules
;;