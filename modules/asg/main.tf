resource "aws_launch_template" "app" {
  name          = "${var.name}-launch-template"
  image_id      = var.ami_id
  instance_type = var.instance_type

  key_name = var.key_name

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [var.security_group_id]
    subnet_id                   = element(var.private_subnets, 0)
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.name}-app-instance"
    }
  }

  user_data = base64encode(<<-EOF
    #!/bin/bash
    echo "Hello from  ASG instance!" > /var/www/html/index.html
    systemctl start httpd
  EOF
  )
}

resource "aws_autoscaling_group" "asg" {
  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }

  vpc_zone_identifier = var.private_subnets
  min_size            = var.min_size
  max_size            = var.max_size
  desired_capacity    = var.desired_capacity

  target_group_arns = [var.target_group_arn]

  tag {
    key                 = "Name"
    value               = "${var.name}-app-instance"
    propagate_at_launch = true
  }
}

data "aws_instances" "app_instances" {
  instance_tags = {
    Name = "${var.name}-app-instance"
  }
}

data "aws_autoscaling_group" "app" {
  name = aws_autoscaling_group.asg.name
}
