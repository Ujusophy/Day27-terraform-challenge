output "alb_dns_name" {
  value = aws_lb.main.dns_name
}

output "main_target_group_arn" {
  description = "The ARN of the main target group"
  value       = aws_lb_target_group.main.arn 
}

output "dns_name" {
  description = "The DNS name of the ALB"
  value       = aws_lb.main.dns_name
}

output "zone_id" {
  description = "The zone ID of the ALB"
  value       = aws_lb.main.zone_id
}

output "alb_name" {
  description = "The name of the ALB"
  value       = aws_lb.main.name
}

output "elb_us_east_dns" {
  value = aws_lb.main.dns_name
}

output "elb_us_east_zone_id" {
  value = aws_lb.main.zone_id
}

output "elb_us_west_dns" {
  value = aws_lb.main_us_west.dns_name
}

output "elb_us_west_zone_id" {
  value = aws_lb.main_us_west.zone_id
}
