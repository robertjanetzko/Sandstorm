type 'a comp = (module Component.Sig with type t = 'a)

type 'a t =
  | Component : 'a comp -> 'a t
  | And : ('a t * 'b t) -> ('a * 'b) t

let c (type a) (module C : Component.Sig with type t = a) = Component (module C)

let rec run : type a. a t -> (Entity.id_t * a) Seq.t =
  fun q ->
  match q with
  | Component x ->
    let module Comp = (val x : Component.Sig with type t = a) in
    Comp.all () |> Seq.map (fun id -> id, Comp.get id)
  | And (x, y) ->
    let left = run x in
    let right = run y in
    let step _left _right = None in
    let s2 = Seq.unfold (fun (l, r) -> step l r) (left, right) in
    s2
;;

(* | _ -> assert false *)

let test_query_1 = c (module DefaultComponents.Position)

(* let test_query_2 = c (module C) *)
(* let test_query_3 = And (test_query_1, test_query_2) *)
(* let test_query_4 = And (test_query_3, c (module Health.C)) *)
(*     let test_query_5 = And (test_query_4, test_query_3)
       let r1 = run test_query_1
       let r2 = run test_query_5 *)

let iterq : type a. a t -> (a -> unit) -> unit =
  fun q f -> run q |> Seq.iter (fun (_id, v) -> f v)
;;

let () = iterq test_query_1 (fun _p -> ())
(* let () = iterq test_query_3 (fun ((_a, _b), _c) -> ()) *)
(* let d (type a) (process : a -> unit) = () *)
