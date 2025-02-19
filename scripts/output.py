import sys
import re
import csv
import argparse

pattern = r"\[\\[32;1m✓\\[0m\]\s(\d+)[\s\d]+?(\d+)\s\/\s\d+\s+(\d\.\ds)\s+(\w+)"

def read_input():
    stats = []
    for line in sys.stdin:
        # print(line)
        match = re.search(pattern, line)
        if match:
            extracted_values = list(match.groups()) 
            # print(extracted_values)
            extracted_values.insert(0, extracted_values[3])
            extracted_values.pop()
            extracted_values.insert(1, extracted_values[2])
            del extracted_values[3]
            stats.append(extracted_values)
    return stats

stats = read_input()

parser = argparse.ArgumentParser(description="Process a filename from the -n flag.")
parser.add_argument("-o", dest="filename", default="stats.csv", help="Specify the filename.")

args = parser.parse_args()
filename = "./csv/" + args.filename


with open(filename, mode="w", newline="") as file:
    writer = csv.writer(file)
    writer.writerow(["Precondition Name", "Pass", "Total", "Time"])
    for row in stats:
        writer.writerow(row)



