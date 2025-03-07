.PHONY: all build run

build:
	opam exec -- dune build

run: build
	opam exec -- dune exec Cobb_PBT

clean:
	opam exec -- dune clean
	python scripts/clean.py