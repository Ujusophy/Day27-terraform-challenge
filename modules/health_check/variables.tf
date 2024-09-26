variable "elb_us_east_dns" {
  type        = string
  description = "DNS name for the ELB in us-east-1"
}

variable "elb_us_west_dns" {
  type        = string
  description = "DNS name for the ELB in us-west-2"
}

variable "domain_name" {
  type        = string
  description = "Domain name for the health check"
}

variable "elb_us_east_zone_id" {
  type        = string
  description = "Zone ID for the ELB in us-east-1"
}

variable "elb_us_west_zone_id" {
  type        = string
  description = "Zone ID for the ELB in us-west-2"
}

variable "zone_id" {
  type        = string
  description = "The ID of the Route53 hosted zone"
}
