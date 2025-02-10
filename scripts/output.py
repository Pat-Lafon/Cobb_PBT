import sys
import re
import csv

pattern = r"\[\\[32;1m✓\\[0m\]\s(\d+)[\s\d]+?(\d+)\s\/\s\d+\s+(\d\.\ds)\s+(\w+)"
# pattern = r"^.+\d+\s+(\d+)\s+(\d+)\s+(\d+)\s\/\s(\d+)\s+(\d\.\ds)\s+([\w,:,\ ]+)"

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
            stats.append(extracted_values)
    return stats

stats = read_input()

with open("stats.csv", mode="w", newline="") as file:
    writer = csv.writer(file)
    writer.writerow(["Name", "Total", "Pass", "Time"])
    for row in stats:
        writer.writerow(row)



