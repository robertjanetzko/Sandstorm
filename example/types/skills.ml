type skill = { name : string }

let skills =
  [| { name = "More Speed" }
   ; { name = "More Firerate" }
   ; { name = "More Damage" }
   ; { name = "More HP" }
  |]
;;

let random_skill () = Random.int @@ Array.length skills
