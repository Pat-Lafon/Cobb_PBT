import os
import matplotlib.pyplot as plt
import csv
import argparse
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
parser = argparse.ArgumentParser(
    description="Generate bar chart for Red-Black Tree only."
)
parser.add_argument("table", help="Specify table [table1|table2].")

args = parser.parse_args()
table = args.table

# TODO: Should this be an argument?
output_dir = "./graphs"
os.makedirs(output_dir, exist_ok=True)

assert (
    table == "table1" or table == "table2"
), "Invalid table name. Use 'table1' or 'table2'."

fontsize = 20
bar_width = 0.6


def create_red_black_tree_graph(table_name):
    fig, ax = plt.subplots(1, 1)
    fig.set_size_inches(10, 7)

    # Set labels
    if table == "table1":
        fig.suptitle("Red-Black Tree Coverage Repaired", fontsize=fontsize)
        ax.set_ylabel("Number of Valid Values", fontsize=fontsize)
    else:
        fig.suptitle(
            f"Red-Black Tree - {table_name} outputs from generator variations",
            fontsize=fontsize,
        )
        ax.set_ylabel("Number of values out of 20k accepted", fontsize=fontsize)

    ax.set_xlabel("Generator variations", fontsize=fontsize)

    # Read data from Red-Black tree CSV
    csv_file = "./csv/red_black_tree/" + table + ".csv"

    data = {}

    try:
        with open(csv_file, "r") as fin:
            csv_reader = csv.reader(fin)
            next(csv_reader)  # Skip header

            rows = list(csv_reader)
            rows.sort(key=lambda row: row[0])

            if table == "table1":
                rows = [
                    r
                    for r in rows
                    if not "_safe" in r[0] and not "_syn" in r[0] and r[0] != "default"
                ]

            for row in rows:
                data[row[0]] = int(row[1])

        # Create the bar graph
        colors = [color_from_name(name) for name in data.keys()]
        x_pos = np.arange(len(data.keys()))

        bars = ax.bar(
            x_pos, list(data.values()), color=colors, edgecolor="black", width=bar_width
        )

        # Set up axes
        ax.set_xticks(x_pos)
        ax.set_ylim(0, 20000)

        # Set x-axis labels based on table type
        if table == "table1":
            names = (
                ["Cobb"] + [str(i) for i in range(1, len(data.keys()) - 1)] + ["sketch"]
            )
        else:
            names = [str(i) for i in range(1, len(data.keys()))] + ["sketch"]

        ax.set_xticklabels(names, rotation=45, ha="right", fontsize=fontsize)
        ax.tick_params(axis="y", labelsize=fontsize)

        # Add x markers for zero values
        for i, value in enumerate(data.values()):
            if value == 0.0:
                ax.plot(x_pos[i], 1000, marker="x", markersize=10, color="red")

        # Add legend
        if table == "table1":
            elements = ["Cobb", "incomplete_variation", "sketch"]
            bar_elements = [bars[0], bars[1], bars[-1]]
            ax.legend(bar_elements, elements, fontsize=fontsize, loc="upper right")
        else:
            elements = ["incomplete_variation", "sketch"]
            bar_elements = [bars[0], bars[-1]]
            ax.legend(bar_elements, elements, fontsize=fontsize, loc="lower right")

        # Save the graph
        plt.tight_layout()
        output_file = os.path.join(output_dir, f"red_black_tree_{table_name}.png")
        plt.savefig(output_file)
        print(f"Graph saved to: {output_file}")

    except FileNotFoundError:
        print(f"Error: Could not find CSV file: {csv_file}")
        print("Please ensure the Red-Black tree data exists in the csv directory.")
    except Exception as e:
        print(f"Error creating graph: {e}")


if __name__ == "__main__":
    create_red_black_tree_graph(table)
