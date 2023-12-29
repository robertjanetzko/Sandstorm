open Raylib
open DefaultComponents

type collisionShape =
  | Circle of float
  | Rect of float * float

module Shape = struct
  type s =
    { shape : collisionShape
    ; mask : int64
    }

  include (val Component.create () : Component.Sig with type t = s)
end

module Impact = struct
  type s =
    { other : Entity.id_t
    ; position : Vector2.t
    }

  include (val Component.create () : Component.Sig with type t = s)
end

module Detector = struct
  let match_mask m1 m2 = Int64.logand m1 m2 > 0L

  let overlap id1 id2 =
    let p1 = Position.get id1 in
    let p2 = Position.get id2 in
    let s1 = Shape.get id1 in
    let s2 = Shape.get id2 in
    if not @@ match_mask s1.mask s2.mask
    then false
    else (
      match s1.shape, s2.shape with
      | Circle r1, Circle r2 -> Vector2.distance p1 p2 < r1 +. r2
      | _ -> false)
  ;;

  let detect id1 id2 =
    if id1 != id2 && overlap id1 id2
    then Impact.set { other = id2; position = Position.get id1 } id1
  ;;

  let process id _s1 _p1 =
    let s = Component.(!?(module Shape) >? (module Position)) in
    Seq.iter (detect id) s
  ;;

  include (val System.create2 process (module Shape) (module Position))
end

module Cleanup = struct
  let process id (_impact : Impact.s) = Impact.remove id

  include (val System.create1 process (module Impact))
end
