let collision_layer_player = 1 lsl 1
let collision_layer_projectile = 1 lsl 2
let collision_layer_experience = 1 lsl 3
let create_mask layers = List.fold_left ( + ) 0 layers
