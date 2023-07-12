#Author; Nicholas Gulrajani
#Description: This is a simple terraform file that creates a local file and outputs the content of the file
terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "2.0.0"
    }
  }
}

provider "local" {}

resource "local_file" "example" {
  filename = "${path.module}/example.txt"
  content  = "Hello, Terraform!"
}

output "file_content" {
  value = local_file.example.content
}

