type 'a comp = (module Component.Sig with type t = 'a)

type 'a query =
  | And : 'c comp * 'a query -> ('c -> 'a) query
  | Query : unit query

exception EmptyQuery

val eval : int -> 'a query -> 'a -> unit
val for_each : 'a. 'a query -> (int -> 'a) -> unit
val ( ^& ) : 'a comp -> 'b query -> ('a -> 'b) query
val ( ^? ) : 'a comp -> 'b comp -> ('a -> 'b -> unit) query
val query : 'a comp -> ('a -> unit) query
