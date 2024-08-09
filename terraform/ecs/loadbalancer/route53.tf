resource "aws_route53_zone" "main" {
  name = var.main_domain
}

resource "aws_route53_record" "example_com" {
  zone_id = aws_route53_zone.main.zone_id
  name    = var.main_domain
  type    = "A"

  alias {
    name                   = aws_lb.loadbalancer.dns_name
    zone_id                = aws_lb.loadbalancer.zone_id
    evaluate_target_health = true
  }
  depends_on = [ aws_lb.loadbalancer ]
}

resource "aws_route53_record" "jenkins_webhook_example_com" {
  zone_id = aws_route53_zone.main.zone_id
  name    = var.jenkins_webhook_domain
  type    = "A"

  alias {
    name                   = aws_lb.loadbalancer.dns_name
    zone_id                = aws_lb.loadbalancer.zone_id
    evaluate_target_health = true
  }
  depends_on = [ aws_lb.loadbalancer ]
}

resource "aws_route53_record" "www_example_com" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "www.${var.main_domain}"
  type    = "CNAME"
  ttl     = 300
  records = [var.main_domain]

  depends_on = [ aws_lb.loadbalancer ]
}