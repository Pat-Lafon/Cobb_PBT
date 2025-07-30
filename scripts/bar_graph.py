import os
import matplotlib.pyplot as plt
import csv
import argparse
import re
import glob

import numpy as np


def color_from_name(name):
    if name == "prog":
        return "#228833"  # "green"
    elif name == "default":
        return "#AA3377"  # "purple"
    elif "sketch" in name:
        return "#4477AA"  # "blue"
    else:
        return "#66CCEE"  # "cyan"


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
    "Sized List",
    "Duplicate List",
    "Unique List",
    "Sorted List",
    "Even List"
]
tree_names = [
    "Depth Tree",
    "Complete Tree",
    "BST",
    "Red-Black Tree",
]

fontsize = 16
bar_width = 0.6
fig_width = 20  # Your figure width


def find_numbers_in_groups(names):
    res = []
    for idx, (name) in enumerate(names):
        path = re.sub(r"-", "_", re.sub(r"\ ", "_", name))

        files = glob.glob("./csv/" + path + "/" + table + ".csv")
        for file in files:
            with open(file, "r") as fin:
                csv_reader = csv.reader(fin)
                # Skip the header
                next(csv_reader)

                rows = list(csv_reader)
                res.append(len(rows))
    return res


def create_graph(names, table_name):
    n_groups = len(names)

    width_ratios = find_numbers_in_groups(names)

    fig, axes = plt.subplots(1, n_groups, sharey=True, width_ratios=width_ratios)

    fig.set_size_inches(fig_width, 5)
    # fig.suptitle(table_name + " outputs from generator variations", fontsize=fontsize)
    # fig.supxlabel("generator variations", fontsize=fontsize)
    fig.supylabel("Number of values out of 20k accepted", fontsize=fontsize, x=0.01)

    # goes through each folder, and matches the csv that matches the table name
    for idx, (name, ax) in enumerate(zip(names, axes)):
        path = re.sub(r"-", "_", re.sub(r"\ ", "_", name))

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

            """             bar_width = 0.8 * (fig_width / (len(data.keys()) * n_groups)) """
            x_pos = np.arange(len(data.keys())) * bar_width

            bars = ax.bar(
                x_pos, data.values(), color=color, edgecolor="black", width=bar_width
            )

            # Add labels and title
            ax.set_xticks(x_pos)
            ax.set_ylim(0, 20000)
            plt.setp(ax.get_yticklabels(), fontsize=fontsize)

            # Hack: How to get names not following implicit order?
            names = (
                (
                    ["default", "Cobb"]
                    + [str(i) for i in range(1, len(data.keys()) - 2)]
                    + ["sketch"]
                )
                if table == "table1"
                else ([str(i) for i in range(1, len(data.keys()))] + ["sketch"])
            )
            ax.set_xticklabels(names, rotation=45, ha="right", fontsize=fontsize)
            ax.set_title(name, fontsize=fontsize)

            # Add x markers for zero values
            for i, value in enumerate(data.values()):
                if value == 0.0:
                    ax.plot(x_pos[i], 1000, marker="x", markersize=10, color="red")

            # Add legend
            elements = (["default", "Cobb"] if table == "table1" else []) + [
                "incomplete_variation",
                "sketch",
            ]
            bar_elements = (
                [bars[0], bars[1]] + [bars[2], bars[-1]]
                if table == "table1"
                else [bars[0], bars[-1]]
            )

        # HACK: do this better
        if idx == n_groups - 1:
            ax.legend(bar_elements, elements, fontsize=fontsize - 2)

    # Add values on top of bars
    # for name, value in data.items():
    #    plt.text(name, value + 1, str(value), ha='center')

    # Display the graph
    plt.tight_layout()
    plt.subplots_adjust(wspace=0.0)
    plt.savefig(os.path.join(output_dir, f"{table_name}_graph.png"))
    # plt.show()


if table == "table1":
    create_graph(list_names, f"{table}_list")
    create_graph(tree_names, f"{table}_tree")
else:
    create_graph(([list_names[0], list_names[-1]] + tree_names), f"{table}_combined")
