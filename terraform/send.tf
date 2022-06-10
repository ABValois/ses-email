# This sets up sending emails via SES verified domains
# Includes DKIM, DMARC, and send SPF

resource "aws_ses_domain_identity" "ses_email" {
  provider = aws.acm
  domain   = var.domain
}

resource "aws_ses_domain_dkim" "ses_email" {
  provider = aws.acm
  domain   = aws_ses_domain_identity.ses_email.domain
}

resource "aws_ses_domain_mail_from" "ses_email" {
  provider               = aws.acm
  domain                 = aws_ses_domain_identity.ses_email.domain
  mail_from_domain       = "noreply.${aws_ses_domain_identity.ses_email.domain}"
  behavior_on_mx_failure = "UseDefaultValue"
}

resource "aws_route53_record" "ses_email" {
  zone_id = data.aws_route53_zone.domain.zone_id
  name    = "_amazonses.${aws_ses_domain_identity.ses_email.id}"
  type    = "TXT"
  ttl     = 600
  records = [aws_ses_domain_identity.ses_email.verification_token]
}

resource "aws_route53_record" "ses_email_dkim" {
  count   = 3
  zone_id = data.aws_route53_zone.domain.zone_id
  name    = "${element(aws_ses_domain_dkim.ses_email.dkim_tokens, count.index)}._domainkey"
  type    = "CNAME"
  ttl     = 600
  records = ["${element(aws_ses_domain_dkim.ses_email.dkim_tokens, count.index)}.dkim.amazonses.com"]
}

resource "aws_route53_record" "ses_email_dmarc_mx" {
  zone_id = data.aws_route53_zone.domain.zone_id
  name    = aws_ses_domain_mail_from.ses_email.mail_from_domain
  type    = "MX"
  ttl     = 600
  records = ["10 feedback-smtp.${data.aws_region.current.name}.amazonses.com"]
}

resource "aws_route53_record" "ses_email_dmarc_spf" {
  zone_id = data.aws_route53_zone.domain.zone_id
  name    = aws_ses_domain_mail_from.ses_email.mail_from_domain
  type    = "TXT"
  ttl     = 600
  records = ["v=spf1 include:amazonses.com -all"]
}

resource "aws_ses_domain_identity_verification" "ses_email" {
  provider   = aws.acm
  domain     = aws_ses_domain_identity.ses_email.id
  depends_on = [aws_route53_record.ses_email]
}
