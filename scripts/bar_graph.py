import matplotlib.pyplot as plt
import csv
import argparse
import re
import glob

# cli
parser = argparse.ArgumentParser(description="args for graphs.")
parser.add_argument("table", help="Specify table [table1|table2_safe].")

args = parser.parse_args()
table = args.table

# list of names for tables
names = [
    "Duplicate list",
    "Sized list",
    "Sorted list",
    "Unique list",
    "Rbtree",
    "Complete tree",
    "Depth tree",
    "Depth bst tree",
]

# goes through each folder, and matches the csv that matches the table name
for name in names:
    path = re.sub(r"\ ", "_", name)

    files = glob.glob("./csv/" + path + "/" + table + ".csv")
    for file in files:

        data = {}

        # reads and creates a map out of the table
        with open(file, "r") as fin:
            csv_reader = csv.reader(fin)
            next(csv_reader)

            rows = list(csv_reader)
            list.sort(rows, key=lambda row: row[0])

            for row in rows:
                # print(row)
                data[row[0]] = int(row[1])

        # Create the bar graph
        plt.figure(figsize=(10, 4))
        # TODO: fix dimensions for sized list/split it into 2, it's a squeeze to fit 9 elements
        plt.bar(data.keys(), data.values(), color="skyblue")

        # Add labels and title
        plt.xlabel(name + " generator variations")
        plt.ylabel("Number of examples out of 20k accepted")
        plt.title(table + " outputs from " + name.lower() + " generator variations")

        # Add values on top of bars
        # for name, value in data.items():
        #    plt.text(name, value + 1, str(value), ha='center')

        # changes width

        # Display the graph
        plt.tight_layout()
        print(file)
        plt.savefig(f"./graphs/{path}_{table}_graph.png")
        # plt.show()
