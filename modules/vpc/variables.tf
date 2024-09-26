variable "cidr_block" {
  type        = string
  description = "CIDR block for the VPC"
}

variable "public_subnets" {
  type        = list(string)
  description = "List of public subnet CIDR blocks"
}

variable "private_subnets" {
  type        = list(string)
  description = "List of private subnet CIDR blocks"
}

variable "public_azs" {
  type        = list(string)
  description = "List of availability zones for public subnets"
}

variable "private_azs" {
  type        = list(string)
  description = "List of availability zones for private subnets"
}

variable "name" {
  type        = string
  description = "Name prefix for resources"
}
