module Collision = Collision
module Component = Component
module DefaultComponents = DefaultComponents
module Entity = Entity
module FollowCamera = FollowCamera
module Game = Game
module ShapeRenderer = ShapeRenderer
module System = System
module World = World
module Timer = Timer

let query = Query.query
let query2 = Query.query2
let ( >& ) = Query.( >& )
let ( >&& ) = Query.( >&& )

let destroy_entity id =
  let modules = !Component.allComponents in
  List.iter (fun (module M : Component.Sig) -> M.remove id) modules
;;
