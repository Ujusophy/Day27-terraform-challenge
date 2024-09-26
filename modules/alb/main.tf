resource "aws_lb" "main" {
  name               = "${var.name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.security_group_id]
  subnets            = var.public_subnets

  tags = {
    Name = "${var.name}-alb"
  }
}

resource "aws_lb_target_group" "main" {
  name     = "${var.name}-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    protocol = "HTTP"
    path     = "/"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}

resource "aws_lb" "main_us_west" {
  provider           = aws.us-west
  name               = "${var.name}-alb-us-west"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.security_group_id]
  subnets            = var.public_subnets

  tags = {
    Name = "${var.name}-alb-us-west"
  }
}

resource "aws_lb_target_group" "main_us_west" {
  provider = aws.us-west
  name     = "${var.name}-target-group-us-west"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    protocol = "HTTP"
    path     = "/"
  }
}

resource "aws_lb_listener" "http_us_west" {
  provider           = aws.us-west
  load_balancer_arn  = aws_lb.main_us_west.arn
  port               = 80
  protocol           = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main_us_west.arn
  }
}
