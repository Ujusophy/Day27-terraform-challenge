resource "aws_cloudwatch_metric_alarm" "ec2_cpu_alarm" {
  alarm_name          = "${var.name}-ec2-cpu-utilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "This metric monitors EC2 instance CPU utilization"
  dimensions = {
    InstanceId = var.ec2_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "elb_latency_alarm" {
  alarm_name          = "${var.name}-elb-latency"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "Latency"
  namespace           = "AWS/ELB"
  period              = 60
  statistic           = "Average"
  threshold           = 0.5
  alarm_description   = "This metric monitors ELB latency"
  dimensions = {
    LoadBalancerName = var.elb_name
  }
}

resource "aws_cloudwatch_metric_alarm" "rds_cpu_alarm" {
  alarm_name          = "${var.name}-rds-cpu-utilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = 120
  statistic           = "Average"
  threshold           = 75
  alarm_description   = "This metric monitors RDS CPU utilization"
  dimensions = {
    DBInstanceIdentifier = var.rds_instance_id
  }
}
