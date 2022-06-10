
data "aws_region" "current" {}

data "aws_route53_zone" "domain" {
  name = var.domain
}
