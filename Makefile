.PHONY: all build run

build:
	opam exec -- dune build

run: build
	opam exec -- dune exec Cobb_PBT

clean:
	opam exec -- dune clean
	python3 scripts/clean.py

results:
	python scripts/output.py -f bin/sized_list/ -o table1.csv
	python scripts/output.py -f bin/sorted_list/ -o table1.csv
	python scripts/output.py -f bin/duplicate_list/ -o table1.csv
	python scripts/output.py -f bin/unique_list/ -o table1.csv
	python scripts/output.py -f bin/rbtree/ -o table1.csv
	python scripts/bar_graph.py table1