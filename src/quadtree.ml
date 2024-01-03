open Raylib

let in_range c r p = Vector2.distance c p <= r

type 'a node =
  { point : Vector2.t
  ; value : 'a
  }

type aabb =
  { center : Vector2.t
  ; half_dimension : float
  }

let contains bb p =
  let px = Vector2.x p in
  let py = Vector2.y p in
  let cx = Vector2.x bb.center in
  let cy = Vector2.y bb.center in
  px >= cx -. bb.half_dimension
  && px <= cx +. bb.half_dimension
  && py >= cy -. bb.half_dimension
  && py <= cy +. bb.half_dimension
;;

let intersects c r bb =
  let h = bb.half_dimension in
  contains bb c
  || in_range c r (Vector2.add bb.center (Vector2.create h ~-.h))
  || in_range c r (Vector2.add bb.center (Vector2.create ~-.h ~-.h))
  || in_range c r (Vector2.add bb.center (Vector2.create ~-.h h))
  || in_range c r (Vector2.add bb.center (Vector2.create h h))
;;

type 'a t =
  { capacity : int
  ; bounds : aabb
  ; mutable data : 'a node list
  ; mutable nw : 'a t option
  ; mutable sw : 'a t option
  ; mutable ne : 'a t option
  ; mutable se : 'a t option
  }

let create ?(capacity = 5) ?(center = 0., 0.) half_dimension =
  match center with
  | x, y ->
    { capacity
    ; bounds = { center = Vector2.create x y; half_dimension }
    ; data = []
    ; nw = None
    ; sw = None
    ; ne = None
    ; se = None
    }
;;

let subdivide t =
  let h = t.bounds.half_dimension /. 2. in
  let x = Vector2.x t.bounds.center in
  let y = Vector2.y t.bounds.center in
  t.nw <- Some (create ~capacity:t.capacity ~center:(x -. h, y -. h) h);
  t.sw <- Some (create ~capacity:t.capacity ~center:(x -. h, y +. h) h);
  t.ne <- Some (create ~capacity:t.capacity ~center:(x +. h, y -. h) h);
  t.se <- Some (create ~capacity:t.capacity ~center:(x +. h, y +. h) h)
;;

let clear t =
  t.data <- [];
  t.nw <- None;
  t.sw <- None;
  t.ne <- None;
  t.se <- None
;;

let insert t p v =
  let rec aux t p v =
    if not (contains t.bounds p)
    then false
    else if List.length t.data < t.capacity
    then (
      t.data <- { point = p; value = v } :: t.data;
      true)
    else (
      if Option.is_none t.nw then subdivide t;
      if aux (Option.get t.nw) p v
      then true
      else if aux (Option.get t.sw) p v
      then true
      else if aux (Option.get t.ne) p v
      then true
      else if aux (Option.get t.se) p v
      then true
      else false)
  in
  let _ = aux t p v in
  ()
;;

let rec query ~center:c ~radius:r t =
  if not (intersects c r t.bounds)
  then []
  else (
    let result =
      List.filter (fun n -> in_range c r n.point) t.data |> List.map (fun n -> n.value)
    in
    if Option.is_none t.nw
    then result
    else
      result
      @ query ~center:c ~radius:r (Option.get t.nw)
      @ query ~center:c ~radius:r (Option.get t.sw)
      @ query ~center:c ~radius:r (Option.get t.ne)
      @ query ~center:c ~radius:r (Option.get t.se))
;;

let rec debug t =
  draw_line_v
    (Vector2.add t.bounds.center (Vector2.create 0. t.bounds.half_dimension))
    (Vector2.add t.bounds.center (Vector2.create 0. ~-.(t.bounds.half_dimension)))
    Color.pink;
  draw_line_v
    (Vector2.add t.bounds.center (Vector2.create t.bounds.half_dimension 0.))
    (Vector2.add t.bounds.center (Vector2.create ~-.(t.bounds.half_dimension) 0.))
    Color.pink;
  if Option.is_none t.nw
  then draw_circle_v t.bounds.center 5. Color.pink
  else (
    debug (Option.get t.nw);
    debug (Option.get t.sw);
    debug (Option.get t.ne);
    debug (Option.get t.se))
;;
