module Position = struct
  type s = Raylib.Vector2.t

  include (val Component.create () : Component.Sig with type t = s)
end
