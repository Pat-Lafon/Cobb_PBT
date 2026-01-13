(lang dune 3.7)

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
  (ocaml
   (>= 4.14))
  (dune
   (>= 3.7))
  (fileutils
   (>= "0.6.0"))
  (core_unix
   (>= "0.15.0"))
  (ocamlformat
   (>= "0.20"))
  (ppxlib
   (>= "0.36.0"))
  (ppx_deriving
   (>= "6.1.0"))
  (ounit2 :with-test)
  (alcotest
   (and :with-test (>= "1.2.0"))))
 (tags
  (topics "to describe" your project)))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/reference/dune-project/index.html
