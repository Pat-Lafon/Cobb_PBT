.PHONY: all build run

build:
	opam exec -- dune build

run: build
	opam exec -- dune exec Cobb_PBT

clean:
	opam exec -- dune clean
	python3 scripts/clean.py
	rm -r graphs
	rm -r csv

results:
	python scripts/output.py -f bin/sized_list/ -o table1.csv
	python scripts/output.py -f bin/sorted_list/ -o table1.csv
	python scripts/output.py -f bin/duplicate_list/ -o table1.csv
	python scripts/output.py -f bin/unique_list/ -o table1.csv
	python scripts/output.py -f bin/complete_tree/ -o table1.csv
	python scripts/output.py -f bin/depth_tree/ -o table1.csv
	python scripts/output.py -f bin/rbtree/ -o table1.csv
	python scripts/output.py -f bin/depth_bst_tree/ -o table1.csv
	python scripts/output.py -f bin/completeness_data/sized_list/ -o table2.csv
	python scripts/output.py -f bin/completeness_data/sorted_list/ -o table2.csv
	python scripts/output.py -f bin/completeness_data/duplicate_list/ -o table2.csv
	python scripts/output.py -f bin/completeness_data/unique_list/ -o table2.csv
	python scripts/output.py -f bin/completeness_data/depth_tree/ -o table2.csv
	python scripts/output.py -f bin/completeness_data/complete_tree/ -o table2.csv
	python scripts/output.py -f bin/completeness_data/depth_bst_tree/ -o table2.csv
	python scripts/output.py -f bin/completeness_data/rbtree/ -o table2.csv
	python scripts/bar_graph.py table1
	python scripts/bar_graph.py table2
