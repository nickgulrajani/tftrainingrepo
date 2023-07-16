# AUTHOR: Nicholas Gulrajani
import os

def create_folder_structure():
    # Create root directory
    os.makedirs("terraform-environments", exist_ok=True)
    os.chdir("terraform-environments")

    # Create main.tf file
    with open("main.tf", "w") as main_tf:
        # Add shared infrastructure code if needed
        main_tf.write("# Shared infrastructure code goes here\n")

    # Create variables.tf file
    with open("variables.tf", "w") as variables_tf:
        # Add shared variables if needed
        variables_tf.write("# Shared variables go here\n")

    # Create qa directory
    os.makedirs("qa", exist_ok=True)
    os.chdir("qa")

    # Create qa.tf file
    with open("qa.tf", "w") as qa_tf:
        qa_tf.write("# QA infrastructure code goes here\n")

    # Create variables.tf file for qa
    with open("variables.tf", "w") as qa_variables_tf:
        qa_variables_tf.write("# QA environment variables go here\n")

    # Create qa.tfvars file
    with open("qa.tfvars", "w") as qa_tfvars:
        # Add QA environment variable values
        qa_tfvars.write("# QA environment variable values go here\n")

    # Create dev directory
    os.makedirs("../dev", exist_ok=True)
    os.chdir("../dev")

    # Create dev.tf file
    with open("dev.tf", "w") as dev_tf:
        dev_tf.write("# Dev infrastructure code goes here\n")

    # Create variables.tf file for dev
    with open("variables.tf", "w") as dev_variables_tf:
        dev_variables_tf.write("# Dev environment variables go here\n")

    # Create dev.tfvars file
    with open("dev.tfvars", "w") as dev_tfvars:
        # Add Dev environment variable values
        dev_tfvars.write("# Dev environment variable values go here\n")

if __name__ == "__main__":
    create_folder_structure()

