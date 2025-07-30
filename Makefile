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
	python3 scripts/output.py -f bin/sized_list/ -o table1.csv
	python3 scripts/output.py -f bin/sorted_list/ -o table1.csv
	python3 scripts/output.py -f bin/duplicate_list/ -o table1.csv
	python3 scripts/output.py -f bin/even_list/ -o table1.csv
	python3 scripts/output.py -f bin/unique_list/ -o table1.csv
	python3 scripts/output.py -f bin/complete_tree/ -o table1.csv
	python3 scripts/output.py -f bin/depth_tree/ -o table1.csv
	python3 scripts/output.py -f bin/red_black_tree/ -o table1.csv
	python3 scripts/output.py -f bin/bst/ -o table1.csv
	python3 scripts/output.py -f bin/completeness_data/sized_list/ -o table2.csv
	python3 scripts/output.py -f bin/completeness_data/sorted_list/ -o table2.csv
	python3 scripts/output.py -f bin/completeness_data/duplicate_list/ -o table2.csv
	python3 scripts/output.py -f bin/completeness_data/even_list/ -o table2.csv
	python3 scripts/output.py -f bin/completeness_data/unique_list/ -o table2.csv
	python3 scripts/output.py -f bin/completeness_data/depth_tree/ -o table2.csv
	python3 scripts/output.py -f bin/completeness_data/complete_tree/ -o table2.csv
	python3 scripts/output.py -f bin/completeness_data/bst/ -o table2.csv
	python3 scripts/output.py -f bin/completeness_data/red_black_tree/ -o table2.csv
	python3 scripts/bar_graph.py table1
	python3 scripts/bar_graph.py table2
