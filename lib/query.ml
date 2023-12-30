type 'a q =
  { component : (module Component.Sig with type t = 'a)
  ; conditions : (module Component.Sig) list
  }

type ('a, 'b) q2 =
  { component1 : (module Component.Sig with type t = 'a)
  ; component2 : (module Component.Sig with type t = 'b)
  ; conditions2 : (module Component.Sig) list
  }

type 'a qu =
  | Q : 'a q -> 'a qu
  | Q2 : ('a, 'b) q2 -> ('a * 'b) qu

let query cmp = Q { component = cmp; conditions = [] }
let query2 cmp1 cmp2 = Q2 { component1 = cmp1; component2 = cmp2; conditions2 = [] }

let query_with q cond =
  match q with
  | Q q1 -> Q { q1 with conditions = cond :: q1.conditions }
  | _ -> assert false
;;

let query_with2 q cond =
  match q with
  | Q2 q2 -> Q2 { q2 with conditions2 = cond :: q2.conditions2 }
  | _ -> assert false
;;

let ( >& ) = query_with
let ( >&& ) = query_with2
