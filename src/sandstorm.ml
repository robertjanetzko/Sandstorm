module Component = Component
module Collision = Collision
module DefaultComponents = Default_components
module Entity = Entity
module FollowCamera = Follow_camera
module Game = Game
module ShapeRenderer = Shape_renderer
module SpriteRenderer = Sprite_renderer
module System = System
module World = World
module Timer = Timer
module Quadtree = Quadtree

(* let query = Query.query
   let query2 = Query.query2
   let ( >& ) = Query.( >& )
   let ( >&& ) = Query.( >&& ) *)

type 'a comp = 'a Qq.comp
type 'a query = 'a Qq.query

let query_eval = Qq.eval
let query_each = Qq.for_each
let query = Qq.query
let ( ^& ) = Qq.( ^& )
let ( ^? ) = Qq.( ^? )

let destroy_entity id =
  let modules = !Component.allComponents in
  List.iter (fun (module M : Component.Sig) -> M.remove id) modules
;;
