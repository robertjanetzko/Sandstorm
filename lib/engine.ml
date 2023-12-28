module Collision = Collision
module Component = Component
module DefaultComponents = DefaultComponents
module Entity = Entity
module FollowCamera = FollowCamera
module Game = Game
module ShapeRenderer = ShapeRenderer
module System = System
module World = World

let query = Component.query2
let ( ^? ) = query

let destroy_entity id =
  let modules = !Component.allComponents in
  List.iter (fun (module M : Component.Sig) -> M.remove id) modules
;;
