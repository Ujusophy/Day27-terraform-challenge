resource "aws_route53_record" "primary" {
  zone_id = var.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = var.elb_us_east_dns
    zone_id                = var.elb_us_east_zone_id
    evaluate_target_health = true
  }

  failover_routing_policy {
    type           = "PRIMARY"
    set_identifier = "primary"
  }

  health_check_id = var.primary_health_check_id
}

resource "aws_route53_record" "secondary" {
  zone_id = var.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = var.elb_us_west_dns
    zone_id                = var.elb_us_west_zone_id
    evaluate_target_health = true
  }

  failover_routing_policy {
    type           = "SECONDARY"
    set_identifier = "secondary"
  }

  health_check_id = var.secondary_health_check_id
}
