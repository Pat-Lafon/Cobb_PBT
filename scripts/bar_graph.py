import matplotlib.pyplot as plt

# Sample dictionary mapping names to numbers
data = {
    "Default_list_gen" : 10152,

    "Sized_list_gen" : 20000,

    "Sized_list_gen_1_synth" : 20000,

    "Sized_list_gen_1_cov" : 10152,
}

# Create the bar graph
plt.figure(figsize=(10, 6))
plt.bar(data.keys(), data.values(), color='skyblue')

# Add labels and title
plt.xlabel('Sized list generator variations')
plt.ylabel('Number of examples out of 20k accepted')
plt.title('Safe outputs from sized list generator variations')

# Add values on top of bars
#for name, value in data.items():
#    plt.text(name, value + 1, str(value), ha='center')

# Display the graph
plt.tight_layout()
plt.show()