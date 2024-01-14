(lang dune 3.12)

(name sandstorm)

(generate_opam_files true)

(source
 (github robertjanetzko/Sandstorm))

(license zlib)

(authors "Robert Janetzko")

(maintainers "robertjanetzko")

(package
 (name sandstorm)
 (synopsis "Ocaml game engine")
 (description
  "a prototype game engine written in OCaml using ECS and raylib")
 (depends ocaml dune))

(package
 (name sandstorm_raylib)
 (synopsis "Ocaml game engine")
 (description
  "a prototype game engine written in OCaml using ECS and raylib")
 (depends
  ocaml
  dune
  sandstorm
  (raylib
   (>= 1.2.0))
  raygui))
