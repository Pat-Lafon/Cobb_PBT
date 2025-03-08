(lang dune 3.16)

(name Cobb_PBT)

(generate_opam_files true)

(source
 (github username/reponame))

(authors "Author Name")

(maintainers "Maintainer Name")

(license LICENSE)

(documentation https://url/to/documentation)

(package
 (name Cobb_PBT)
 (synopsis "A short synopsis")
 (description "A longer description")
 (depends
  ocaml
  dune
  (core_unix
   (= v0.15.0))
  (ocamlformat
   (= "0.26.1")))
 (tags
  (topics "to describe" your project)))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/reference/dune-project/index.html
