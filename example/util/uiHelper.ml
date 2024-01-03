open Sandstorm
open Components.Ui

let showGameOver () = Entity.create [ Menu.create (); GameOver.create () ]

let showLevelUp () =
  Entity.create
    [ Menu.create ()
    ; LevelUp.create
        { skill_id_1 = Types.Skills.random_skill ()
        ; skill_id_2 = Types.Skills.random_skill ()
        ; skill_id_3 = Types.Skills.random_skill ()
        }
    ]
;;
