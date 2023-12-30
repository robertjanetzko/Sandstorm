module Collision = Collision
module Component = Component
module DefaultComponents = Default_components
module Entity = Entity
module FollowCamera = Follow_camera
module Game = Game
module ShapeRenderer = Shape_renderer
module SpriteRenderer = Sprite_renderer
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
