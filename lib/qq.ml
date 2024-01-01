type 'a comp = (module Component.Sig with type t = 'a)

type ('a, 'b) query =
  | And : 'c comp * ('a, 'b) query -> ('c -> 'a, 'b) query
  | Query : ('b, 'b) query

let rec evaluate_query : type a b. int -> a -> (a, b) query -> b =
  fun id f args ->
  match args with
  | And ((module M), r) -> evaluate_query id (f (M.get id)) r
  | Query -> f
;;

let eval id q f = evaluate_query id f q
let query m = And (m, Query)
let query_with m q = And (m, q)

let () =
  eval
    123
    (query (module Collision.Impact) |> query_with (module Default_components.Position))
    (fun _p1 _p2 -> ())
;;

let q1 = Query
let q2 = And ((module Collision.Impact), q1)
let q3 = And ((module Default_components.Position), q2)
let q4 = And ((module Default_components.Velocity), q3)
let () = eval 123 q3 (fun _p1 _p2 -> ())
