import os
import matplotlib.pyplot as plt
import csv
import argparse
import re
import glob

import numpy as np


def color_from_name(name):
    if name == "prog":
        return "red"
    elif name == "default":
        return "blue"
    elif "sketch" in name:
        return "purple"
    else:
        return "green"


# cli
parser = argparse.ArgumentParser(description="args for graphs.")
parser.add_argument("table", help="Specify table [table1|table2].")

args = parser.parse_args()
table = args.table

# TODO: Should this be an argument?
output_dir = "./graphs"
os.makedirs(output_dir, exist_ok=True)

assert (
    table == "table1" or table == "table2"
), "Invalid table name. Use 'table1' or 'table2'."

# list of names for tables
list_names = [
    "Duplicate list",
    "Sized list",
    "Sorted list",
    "Unique list",
]
tree_names = [
    "Rbtree",
    "Complete tree",
    "Depth tree",
    "Depth bst tree",
]

bar_width = 0.6


def create_graph(names, table_name):
    n_groups = len(names)

    fig, axes = plt.subplots(1, n_groups, figsize=(25, 10), sharey=True)

    fig.suptitle(table_name + " outputs from generator variations", fontsize=16)
    fig.supxlabel("generator variations")
    fig.supylabel("Number of examples out of 20k accepted")

    # goes through each folder, and matches the csv that matches the table name
    for name, ax in zip(names, axes):
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
                if table == "table1":
                    rows = [
                        r for r in rows if not "_safe" in r[0] and not "_syn" in r[0]
                    ]

                for row in rows:
                    # print(row)
                    data[row[0]] = int(row[1])

            # Create the bar graph
            color = [color_from_name(name) for name in data.keys()]
            x_pos = np.arange(len(data.keys()))
            # TODO: Give name to section?
            ax.bar(x_pos, data.values(), color=color, width=bar_width)

            # Add labels and title
            ax.set_xticks(x_pos)
            ax.set_xticklabels(data.keys(), rotation=45, ha="right")
            ax.set_title(name)

    # Add values on top of bars
    # for name, value in data.items():
    #    plt.text(name, value + 1, str(value), ha='center')

    # changes width

    # Display the graph
    # plt.tight_layout()
    plt.savefig(os.path.join(output_dir, f"{table_name}_graph.png"))
    # plt.show()


create_graph(list_names, f"{table}_list")
create_graph(tree_names, f"{table}_tree")
