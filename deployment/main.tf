
module "main" {
  source = "../terraform"

  domain       = "octatoniq.com"
  default_tags = local.global_tags
}
