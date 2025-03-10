import argparse
import glob
import sys
import re

parser = argparse.ArgumentParser(description="Process.")
parser.add_argument("folder", help="Specify the folder.")

args = parser.parse_args()
folder = args.folder

err_pattern = r"(Err)"
stop_pattern = r"let\["


if folder is not None:

    pattern = re.compile(r"prog[4-9]_(cov|safe)\.ml")
    # pattern = r"prog[4-9]_(cov|safe)\.ml"
    files = glob.glob(folder + "prog*.ml")  # Get all matching files
    matched_files = [f for f in files if pattern.search(f)]
    # matched_files = []
    # for f in files:
    #     if re.rese(pattern, f):
    #         matched_files.append(f)

    # files = glob.glob(folder + "prog4_safe.ml")
    # print(matched_files)
    # print(len(matched_files))
    for file in files:
        try:
            with open(file, "r") as fin:
                lines = fin.readlines()
                print(lines)

            with open(file, "w") as fout:
                fout.write("open Combinators\n")
                for line in lines:
                    # new_line = re.sub(err_pattern, "raise BailOut", line) 
                    match = re.match(stop_pattern, line)
                    if match:
                        break
                    fout.write(line)
                    

        except FileNotFoundError:
            print(f"Error: The file '{file}' was not found.")