import argparse
import glob
import sys
import re

parser = argparse.ArgumentParser(description="Process.")
parser.add_argument("folder", help="Specify the folder.")

args = parser.parse_args()
folder = args.folder

pattern = r"(Err)"


if folder is not None:
    files = glob.glob(folder + "*.ml")
    # print(files)
    stats = []
    for file in files:
        try:
            with open(file, "r") as fin:
                lines = fin.readlines()
                print(lines)

            with open(file, "w") as fout:
                for line in lines:
                    new_line = re.sub(pattern, "raise BailOut", line) 
                    print(new_line)
                    fout.write(new_line)

        except FileNotFoundError:
            print(f"Error: The file '{file}' was not found.")