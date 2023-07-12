# Author: Nicholas Gulrajani
# Description: Terraform lookup (fallback) example with a module
variable "config" {
  type = map(string)

  default = {
    key1 = "value1"
    key2 = "value2"
    key3 = "value3"
  }
}

module "example_module" {
  source        = "./example_module"
  config_value  = lookup(var.config, "key4", "default-value")
}

output "config_value" {
  value = module.example_module.config_value
}

