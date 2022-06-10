
terraform {
  backend "s3" {
    bucket = "tfstate-720421352211"
    key    = "ses-email.tfstate"
    region = "us-east-2"
  }
}
