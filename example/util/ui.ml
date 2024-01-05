open Sandstorm
open Components.Ui

let show_game_over () = Entity.create [ Menu.create (); GameOver.create () ]

let show_level_up () =
  Entity.create
    [ Menu.create ()
    ; LevelUp.create
        { skill_id_1 = Types.Skills.random_skill ()
        ; skill_id_2 = Types.Skills.random_skill ()
        ; skill_id_3 = Types.Skills.random_skill ()
        }
    ]
;;
