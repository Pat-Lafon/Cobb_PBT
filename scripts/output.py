import sys
import re
import csv
import argparse

parser = argparse.ArgumentParser(description="Process a filename from the -n flag.")
parser.add_argument("input_file", help="Specify the input file.")
parser.add_argument("-o", dest="output_file", default="stats.csv", help="Specify the filename.")

args = parser.parse_args()
fin = args.input_file
fout = "./csv/" + args.output_file

pattern = r"\[\\[32;1m✓\\[0m\]\s(\d+)[\s\d]+?(\d+)\s\/\s\d+\s+(\d\.\ds)\s+(\w+)"

def read_input():
    stats = []
    try:
        with open(fin, "r") as file_in:
            for line in file_in:
                match = re.search(pattern, line)
                if match:
                    extracted_values = list(match.groups()) 
                    # print(extracted_values)
                    extracted_values.insert(0, extracted_values[3])
                    extracted_values.pop()
                    extracted_values.insert(1, extracted_values[2])
                    del extracted_values[3]
                    stats.append(extracted_values)
                
    except FileNotFoundError:
        print(f"Error: The file '{fin}' was not found.")

    return stats
    # for line in sys.stdin:
    #     # print(line)
    #     match = re.search(pattern, line)
    #     if match:
    #         extracted_values = list(match.groups()) 
    #         # print(extracted_values)
    #         extracted_values.insert(0, extracted_values[3])
    #         extracted_values.pop()
    #         extracted_values.insert(1, extracted_values[2])
    #         del extracted_values[3]
    #         stats.append(extracted_values)
    # return stats

stats = read_input()


with open(fout, mode="w", newline="") as file_out:
    writer = csv.writer(file_out)
    writer.writerow(["Precondition Name", "Pass", "Total", "Time"])
    for row in stats:
        writer.writerow(row)



