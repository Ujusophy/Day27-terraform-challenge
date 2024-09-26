variable "name" {
  type        = string
  description = "Name prefix for the CloudWatch alarms"
}

variable "ec2_instance_id" {
  type        = string
  description = "EC2 instance ID for monitoring"
}

variable "elb_name" {
  type        = string
  description = "ELB name for monitoring"
}

variable "rds_instance_id" {
  type        = string
  description = "RDS instance ID for monitoring"
}
