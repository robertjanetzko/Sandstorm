open Sandstorm
open Sandstorm_raylib_components
open Raylib

let on_interaction id =
  print_endline (string_of_int id);
  destroy_entity id
;;

let create_obj x y =
  let open Survival_components in
  Entity.create
    [ Position.create @@ Vector2.create x y
    ; Shape.create @@ Circle (10., Color.blue)
    ; Interaction.create
        { range = 30.
        ; single = false
        ; action = Interaction.Progress.step ~max:2. ~decay:2. ~completion:on_interaction
        }
    ]
;;

let start () =
  create_obj 100. 100.;
  create_obj 130. 120.;
  Player.create_player ()
;;
