type 'a comp = (module Component.Sig with type t = 'a)

type 'a query =
  | And : 'c comp * 'a query -> ('c -> 'a) query
  | Query : unit query

let rec evaluate_query : type a. int -> a -> a query -> unit =
  fun id f args ->
  match args with
  | Query -> f
  | And ((module M), r) ->
    (match M.get_opt id with
     | Some m -> evaluate_query id (f m) r
     | None -> ())
;;

let rec match_query : type a. int -> a query -> bool =
  fun id args ->
  match args with
  | Query -> true
  | And ((module M), r) -> if M.is id then match_query id r else false
;;

exception EmptyQuery

let eval id q f = evaluate_query id f q
let is id q = match_query id q
let query m = And (m, Query)
let query_with m q = And (m, q)
let ( ^& ) a b = query_with a b
let ( ^? ) a b = query_with a (query b)

let for_each : type a. a query -> (int -> a) -> unit =
  fun query f ->
  let rec aux : type a. int -> a -> a query -> unit =
    fun id f query ->
    match query with
    | Query -> f
    | And ((module M), r) ->
      (match M.get_opt id with
       | None -> ()
       | Some m -> aux id (f m) r)
  in
  match query with
  | And ((module M), r) -> M.iter (fun id m -> aux id (f id m) r)
  | _ -> raise EmptyQuery
;;

let iter : type a. a query -> (int -> a) -> Entity.id_t list -> unit =
  fun query f list -> List.iter (fun id -> evaluate_query id (f id) query) list
;;
