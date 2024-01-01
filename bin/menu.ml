open Engine

module C = struct
  type s = unit

  include (val Component.create () : Component.Sig with type t = s)
end

module LevelUp = struct
  type s = unit

  include (val Component.create () : Component.Sig with type t = s)
end

module GameOver = struct
  type s = unit

  include (val Component.create () : Component.Sig with type t = s)
end

let showLevelUp () = Entity.create [ C.create (); LevelUp.create () ]
let showGameOver () = Entity.create [ C.create (); GameOver.create () ]
