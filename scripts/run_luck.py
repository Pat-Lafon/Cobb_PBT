import os
import re
import time
import subprocess
import csv

# Parameters
luck_dir = "Luck/luck"
luck_example_dir = "examples"
files = [1, 2, 3, 4, 5, 6]
num_evals = [1000, 10000]
timeout = 300 # 5 minutes


# Setup
os.chdir(luck_dir)

result_build = subprocess.run("cabal build luck", capture_output=True, text=True, timeout=timeout)

assert result_build.returncode == 0

## Black height, num generated, time
results_triple = []

## Luck extraction pattern
pattern = r"Time: (\d+\.\d+)s\n(\d+)"

# Do the thing
for file_num in files:
    # Do a test run
    cmd = f"cabal run luck -- {luck_example_dir}/RBT_{file_num}.luck --mode=evaluate --maxUnroll=5 ---evaltries 10 ---intrangemin 0 ---intrangemax 42424242 ---defdepth 20".split(
        " "
    )

    result = subprocess.run(cmd, capture_output=True, text=True, timeout=timeout)

    assert result.returncode == 0

    for num in num_evals:
        print(f"Running RBT_{file_num}.luck with {num}")

        cmd = f"cabal run luck -- {luck_example_dir}/RBT_{file_num}.luck --mode=evaluate --maxUnroll=5 ---evaltries {num} ---intrangemin 0 ---intrangemax 42424242 ---defdepth 20"

        print(f"Running command: {cmd}")
        cmd = cmd.split(" ")

        # Simple example - run a command and get the output

        try:
            """start_time = time.perf_counter()"""
            result = subprocess.run(
                cmd, capture_output=True, text=True, timeout=timeout
            )
            """ end_time = time.perf_counter() """
            """ print(f"Time taken: {end_time - start_time:.3f}s") """
            print(result.stdout)
            match = re.search(pattern, result.stdout)

            # Check the return code
            print(f"Return code: {result.returncode}")

            if match:
                time = match.group(1)
                print(f"Time taken: {time}s")
                results_triple.append((file_num, num, float(time)))

            # If there was an error
            if result.stderr:
                print(f"Error: {result.stderr}")
        except subprocess.TimeoutExpired:
            print("Command timed out")

print("Results:")
for result in results_triple:
    print(result)

os.chdir("../../bin/enumeration_data")

with open("luck_results.csv.results", "w") as f:
    writer = csv.writer(f)
    writer.writerow(["Black height", "Num generated", "Time"])
    writer.writerows(results_triple)