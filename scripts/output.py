import sys
import re
import csv
import argparse
import glob

parser = argparse.ArgumentParser(description="Process.")
parser.add_argument("-f", dest="folder", default=None, help="Specify the folder.")
parser.add_argument("-i", dest="input_file", default=None, help="Specify the input file.")
parser.add_argument("-o", dest="output_file", default="stats.csv", help="Specify the output file.")
# ex: output.py -f sized_list -o table1.csv

args = parser.parse_args()
folder = args.folder
fin = args.input_file
# fout = "./csv/" + args.output_file

# sorted_list filess have [[31;1m✗[0m] becuase of failures
pattern = r"\[\\[3[12];1m[✗✓]\\[0m\]\s(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s\/\s\d+\s+(\d+\.\d+s)\s(\w+)"
folder_pattern = r"\/([^\/]+)\/$"

if folder is not None:
    name = re.search(folder_pattern, folder)

    fout = "./csv/" + list(name.groups())[0] + "/" + args.output_file

    files = glob.glob(folder + "*.result")
    # print(files)
    stats = []
    for file in files:
        try:
            with open(file, "r") as file_in:
                for line in file_in:
                    match = re.search(pattern, line)
                    if match:
                        print(file)
                        extracted_values = list(match.groups()) 
                        extracted_values_dict = {
                            "generated" : extracted_values[0],
                            "error" : extracted_values[1],
                            "fail" : extracted_values[2],
                            "pass" : extracted_values[3],
                            "time" : extracted_values[4],
                            "name" : extracted_values[5]
                        }
                        stats.append([extracted_values_dict["name"], extracted_values_dict["pass"], extracted_values_dict["fail"], 
                        extracted_values_dict["generated"], extracted_values_dict["time"], ])
                        break
                    
        except FileNotFoundError:
            print(f"Error: The file '{file}' was not found.")


else:
    stats = []
    try:
        with open(fin, "r") as file_in:
            for line in file_in:
                match = re.search(pattern, line)
                if match:
                    extracted_values = list(match.groups()) 
                    extracted_values_dict = {
                        "generated" : extracted_values[0],
                        "error" : extracted_values[1],
                        "fail" : extracted_values[2],
                        "pass" : extracted_values[3],
                        "time" : extracted_values[4],
                        "name" : extracted_values[5]
                    }
                    stats.append([extracted_values_dict["name"], extracted_values_dict["pass"], extracted_values_dict["fail"], 
                    extracted_values_dict["generated"], extracted_values_dict["time"], ])
            
    except FileNotFoundError:
        print(f"Error: The file '{fin}' was not found.")


with open(fout, mode="w", newline="") as file_out:
    writer = csv.writer(file_out)
    writer.writerow(["Generator Name", "Pass", "Fail", "Total", "Time"])
    for row in stats:
        writer.writerow(row)



