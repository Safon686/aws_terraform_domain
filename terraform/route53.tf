data "aws_route53_zone" "hosted_zone" {
 name      = var.domain_name
}

resource "aws_route53_record" "www" {
  zone_id  = data.aws_route53_zone.hosted_zone.zone_id
  name     = "www"
  type     = "A"

  alias {
    name                   = aws_lb.web.dns_name
    zone_id                = aws_lb.web.zone_id
    evaluate_target_health = true
  }
}
resource "aws_route53_record" "myapp" {
  zone_id  = data.aws_route53_zone.hosted_zone.zone_id
  name     = "myapp"
  type     = "A"

  alias {
    name                   = aws_lb.web.dns_name
    zone_id                = aws_lb.web.zone_id
    evaluate_target_health = true
  }
}
resource "aws_route53_record" "def" {
  zone_id  = data.aws_route53_zone.hosted_zone.zone_id
  name     = ""
  type     = "A"

  alias {
    name                   = aws_lb.web.dns_name
    zone_id                = aws_lb.web.zone_id
    evaluate_target_health = true
  }
}