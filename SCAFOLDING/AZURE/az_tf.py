# This program demonstrates how to create a directory structure and required files.
# 
# Author: Nicholas Gulrajani 
# Version: 1.1
# Date: 2023-04-19

import os

# Define the directory structure
directories = [
    "terraform",
    "terraform/modules",
    "terraform/modules/app_service",
    "terraform/modules/cosmos_db",
    "terraform/modules/virtual_network",
    "terraform/environments",
    "terraform/environments/dev",
    "terraform/environments/dev/jupiter",
    "terraform/environments/dev/mars",
    "terraform/environments/dev/saturn",
    "terraform/environments/prod",
    "terraform/environments/prod/jupiter",
    "terraform/environments/prod/mars",
    "terraform/environments/prod/saturn",
    "terraform/environments/shared"
]

# Define the files to be created in each directory
files = [
    ("terraform", ["main.tf", "outputs.tf", "variables.tf"]),
    ("terraform/environments", ["variables.tf", "provider.tf"]),
    ("terraform/environments/shared", ["modules.tf", "outputs.tf", "variables.tf", "provider.tf"]),
    ("terraform/modules/app_service", ["main.tf", "outputs.tf", "variables.tf"]),
    ("terraform/modules/cosmos_db", ["main.tf", "outputs.tf", "variables.tf"]),
    ("terraform/modules/virtual_network", ["main.tf", "outputs.tf", "variables.tf"]),
    ("terraform/environments/dev/jupiter", ["main.tf", "outputs.tf", "variables.tf"]),
    ("terraform/environments/dev/mars", ["main.tf", "outputs.tf", "variables.tf"]),
    ("terraform/environments/dev/saturn", ["main.tf", "outputs.tf", "variables.tf"]),
    ("terraform/environments/prod/jupiter", ["main.tf", "outputs.tf", "variables.tf"]),
    ("terraform/environments/prod/mars", ["main.tf", "outputs.tf", "variables.tf"]),
    ("terraform/environments/prod/saturn", ["main.tf", "outputs.tf", "variables.tf"])
]

# Create the directories and files
for directory in directories:
    if not os.path.exists(directory):
        os.makedirs(directory)
    for filename in files:
        if directory == filename[0]:
            for file in filename[1]:
                with open(os.path.join(directory, file), "w") as f:
                    f.write("")

