import matplotlib.pyplot as plt
import numpy as np

# Sample data: multiple dictionaries with x-y pairs
data = {
    "Luck 1k": {1: 0.2, 2: 0.53, 3: 1.43, 4: 20.65},
    #"Team B": {1: 3, 2: 8, 3: 6, 4: 9, 5: 11},
    #"Team C": {1: 6, 2: 4, 3: 7, 4: 8, 5: 9}
}

# Create the line graph
plt.figure(figsize=(10, 4))

# Plot each dictionary as a separate line
for name, values in data.items():
    # Extract x and y values
    x_values = list(values.keys())
    y_values = list(values.values())

    # Plot this line with a label
    plt.plot(x_values, y_values, marker='o', linestyle='-', label=name)

# Add labels and title
plt.xlabel('RBTree depth')
plt.ylabel('Time in seconds')
plt.title('Time to generate RBTrees')

plt.xticks(np.arange(min(x_values), max(x_values) + 1, 1))

plt.yscale('log')

# Add legend to identify each line
plt.legend()

# Add grid for better readability
plt.grid(True, linestyle='--', alpha=0.7)

# Display the graph
plt.tight_layout()
plt.show()