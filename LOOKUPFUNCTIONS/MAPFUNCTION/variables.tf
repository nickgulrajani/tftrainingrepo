variable "environment" {
  type        = string
  description = "Environment for the resources."
  default     = "dev"
}

variable "dns_servers" {
  type    = map(string)
  default = {
    default = "8.8.8.8"
    dev     = "10.0.0.1"
    prod    = "10.1.0.1"
  }
}



