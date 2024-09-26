output "ec2_cpu_alarm_arn" {
  value = aws_cloudwatch_metric_alarm.ec2_cpu_alarm.arn
}

output "elb_latency_alarm_arn" {
  value = aws_cloudwatch_metric_alarm.elb_latency_alarm.arn
}

output "rds_cpu_alarm_arn" {
  value = aws_cloudwatch_metric_alarm.rds_cpu_alarm.arn
}
