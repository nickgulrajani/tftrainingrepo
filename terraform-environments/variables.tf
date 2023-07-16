# Shared variables go here

# Define any shared variables
# For example, you can define common variables such as Azure subscription ID or tenant ID here

# Include environment-specific variable files
variable "dev_location" {
  type    = string
  default = "westeurope"
}

variable "dev_resource_group_name" {
  type    = string
  default = "nick-dev-resource-group"
}

# Include the variables for the 'qa' environment
variable "qa_location" {
  type    = string
  default = "westeurope"
}

variable "qa_resource_group_name" {
  type    = string
  default = "nick-qa-resource-group"
}

