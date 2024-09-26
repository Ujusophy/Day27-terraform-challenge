resource "aws_route53_health_check" "primary" {
  fqdn             = var.elb_us_east_dns
  type             = "HTTP"
  port             = 80
  resource_path    = "/"
  failure_threshold = 3
  request_interval  = 30
}

resource "aws_route53_health_check" "secondary" {
  fqdn             = var.elb_us_west_dns
  type             = "HTTP"
  port             = 80
  resource_path    = "/"
  failure_threshold = 3
  request_interval  = 30
}
