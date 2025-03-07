import os
import shutil


starting_dir = "./bin/"

root_path = os.path.abspath(starting_dir)

# Walk through all directories
for dirpath, dirnames, filenames in os.walk(root_path, topdown=False):
    print(f"dirpath: {dirpath}")
    print(f"dirnames: {dirnames}")
    # This means it gave use the full path with no middle-man
    if dirnames == []:
        for filename in filenames[:]:
            if filename.endswith(".result"):
                full_path = os.path.join(dirpath, filename)
                print(f"full_path: {full_path}")
                os.remove(full_path)
