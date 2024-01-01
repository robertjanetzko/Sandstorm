let rec insertion_sort ( >: ) = function
  | [] -> []
  | x :: tl -> insert ( >: ) x (insertion_sort ( >: ) tl)

and insert ( >: ) x = function
  | [] -> [ x ]
  | y :: tl when x >: y -> y :: insert ( >: ) x tl
  | l -> x :: l
;;
