import matplotlib.pyplot as plt
import numpy as np

# Sample data: multiple dictionaries with x-y pairs
""" data = {
    # "Luck 1k": {1: 0.2, 2: 0.53, 3: 1.43, 4: 20.65},
    # "Team B": {1: 3, 2: 8, 3: 6, 4: 9, 5: 11},
    # "Team C": {1: 6, 2: 4, 3: 7, 4: 8, 5: 9}
}
 """
import csv
import os


def parse_csv_files(file_paths):
    # Dictionary to store the results
    results = {}

    for file_path in file_paths:
        # Extract filename without extension
        file_name = os.path.splitext(os.path.basename(file_path))[0]

        print(f"Processing file: {file_name}")

        with open(file_path, "r") as csv_file:
            csv_reader = csv.DictReader(csv_file)

            # Process each row in the CSV
            for row in csv_reader:

                black_height = int(row["Black height"])
                num_generated = int(row["Num generated"])
                time = float(row["Time"])

                # Create key for the dictionary (file name + num generated)
                key = f"{file_name}_{num_generated}"

                # Create or update the nested dictionary
                if key not in results:
                    results[key] = {}

                # Add black height -> time mapping
                results[key][black_height] = time

    return results


# Example usage
file_paths = [
    "../bin/enumeration_data/default_results.csv.results",
    "../bin/enumeration_data/luck_results.csv.results",
    "../bin/enumeration_data/synthesis_results.csv.results",
]

data_dict = parse_csv_files(file_paths)
print(data_dict)


# Create the line graph
plt.figure(figsize=(10, 4))

assert len(data_dict) > 0
x_values = []

# Plot each dictionary as a separate line
for name, values in data_dict.items():
    # Extract x and y values
    x_values = list(values.keys())
    y_values = list(values.values())

    # Plot this line with a label
    plt.plot(x_values, y_values, marker="o", linestyle="-", label=name)

# Add labels and title
plt.xlabel("RBTree black height")
plt.ylabel("Time in seconds")
plt.title("Time to generate RBTrees of varying depths")

plt.xticks(np.arange(min(x_values), max(x_values) + 1, 1))

plt.yscale("log")

# Add legend to identify each line
plt.legend()

# Add grid for better readability
plt.grid(True, linestyle="--", alpha=0.7)

# Display the graph
plt.tight_layout()
plt.show()
