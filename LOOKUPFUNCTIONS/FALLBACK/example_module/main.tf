# Author: Nicholas Gulrajani
# Description: Terraform lookup (fallback) example with a module

variable "config_value" {
  type = string
}

output "config_value" {
  value = var.config_value
}

