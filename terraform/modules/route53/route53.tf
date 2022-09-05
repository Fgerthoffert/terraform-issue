data "aws_route53_zone" "sandbox_root" {
  name = "B.REDACTED.com."
}

resource "aws_route53_zone" "perf_r53_zone_public" {
  name = var.env_public_domain

  tags = {
    "Name" = "${var.env_prefix}-vpc"
  }
}

resource "aws_route53_zone" "perf_r53_zone_private" {
  name = var.env_private_domain

  tags = {
    "Name" = "${var.env_prefix}-vpc_private"
  }

  vpc {
    vpc_id = var.vpc_id
  }
}

resource "aws_route53_record" "perf_r53_ns_public" {
  zone_id = data.aws_route53_zone.sandbox_root.zone_id
  name    = var.env_public_domain
  type    = "NS"
  ttl     = "30"
  records = aws_route53_zone.perf_r53_zone_public.name_servers
}
