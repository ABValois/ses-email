
terraform {
  required_version = ">=1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.9.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.2.2"
    }
  }
}

provider "aws" {
  region = "us-east-2"

  default_tags {
    tags = local.global_tags
  }
}
