variable "ami_id" {
  type        = string
  description = "AMI ID for the EC2 instances"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
}

variable "key_name" {
  type        = string
  description = "EC2 Key Pair Name"
}

variable "private_subnets" {
  type        = list(string)
  description = "List of private subnet IDs"
}

variable "security_group_id" {
  type        = string
  description = "Security group ID for EC2 instances"
}

variable "min_size" {
  type        = number
  description = "Minimum number of instances in ASG"
}

variable "max_size" {
  type        = number
  description = "Maximum number of instances in ASG"
}

variable "desired_capacity" {
  type        = number
  description = "Desired number of instances in ASG"
}

variable "target_group_arn" {
  type        = string
  description = "Target group ARN for the Load Balancer"
}

variable "name" {
  type        = string
  description = "Name prefix for the ASG resources"
}
