
provider "aws" { # need this one since there is no us-east-2 ACM for ssl stuff
  alias  = "acm"
  region = "us-east-1"

  default_tags {
    tags = var.default_tags
  }
}
