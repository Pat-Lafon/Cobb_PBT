import sys
import re
import csv

# pattern = r"(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s\/\s(\d+)\s+(\d\.\ds)\s+([\w,:,\ ]+)"
pattern = r"^.+\d+\s+(\d+)\s+(\d+)\s+(\d+)\s\/\s(\d+)\s+(\d\.\ds)\s+([\w,:,\ ]+)"

def read_input():
    stats = []
    for line in sys.stdin:
        print(line)
        match = re.search(pattern, line)
        if match:
            extracted_values = list(match.groups()) 
            extracted_values.insert(0, extracted_values[5])
            extracted_values.pop()
            print(extracted_values)
            stats.append(extracted_values)
    return stats

stats = read_input()

with open("stats.cvs", mode="w", newline="") as file:
    writer = csv.writer(file)
    writer.writerow(["Name", "Error", "Pass", "Total", "Time"])
    for row in stats:
        writer.writerow(row)



