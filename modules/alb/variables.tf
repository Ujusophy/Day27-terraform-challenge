variable "name" {
  type        = string
  description = "Name prefix for ALB resources"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where the ALB will be deployed"
}

variable "public_subnets" {
  type        = list(string)
  description = "List of public subnet IDs"
}

variable "security_group_id" {
  type        = string
  description = "Security group ID for the ALB"
}
