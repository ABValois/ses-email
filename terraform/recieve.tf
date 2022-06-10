# This sets up forwarding to gmail via improv.mx https://app.improvmx.com/domains/octatoniq.com/aliases
# Includes recieve SPF

resource "aws_route53_record" "improvmx_email_mx" {
  zone_id = data.aws_route53_zone.domain.id
  name    = var.domain
  type    = "MX"
  ttl     = 600

  records = [
    "10 mx1.improvmx.com",
    "20 mx2.improvmx.com",
  ]
}

resource "aws_route53_record" "improvmx_email_txt" {
  zone_id = data.aws_route53_zone.domain.id
  name    = var.domain
  type    = "TXT"
  ttl     = 600

  records = [
    "v=spf1 include:spf.improvmx.com ~all",
  ]
}
