open Sandstorm

module Menu = struct
  type s = unit

  include (val Component.create () : Component.Sig with type t = s)
end

module GameOver = struct
  type s = unit

  include (val Component.create () : Component.Sig with type t = s)
end

module LevelUp = struct
  type s =
    { skill_id_1 : int
    ; skill_id_2 : int
    ; skill_id_3 : int
    }

  include (val Component.create () : Component.Sig with type t = s)
end
