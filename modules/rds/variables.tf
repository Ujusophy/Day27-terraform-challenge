variable "name" {
  type        = string
  description = "Name prefix for RDS resources"
}

variable "db_name" {
  type        = string
  description = "Database name"
}

variable "db_username" {
  type        = string
  description = "Database username"
}

variable "db_password" {
  type        = string
  description = "Database password"
  sensitive   = true
}

variable "primary_az" {
  type        = string
  description = "Availability Zone for the primary RDS instance"
}

variable "replica_az" {
  type        = string
  description = "Availability Zone for the RDS read replica"
}

variable "security_group_id" {
  type        = string
  description = "Security group ID for RDS instances"
}

variable "subnet_group" {
  type        = string
  description = "DB subnet group"
}

variable "create_replica" {
  type        = bool
  default     = true
  description = "Whether to create a read replica"
}

variable "subnet_ids" {
  description = "List of subnet IDs for the RDS DB subnet group"
  type        = list(string)
}

