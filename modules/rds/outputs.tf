output "primary_rds_endpoint" {
  value = aws_db_instance.primary.endpoint
}

output "read_replica_endpoints" {
  value = [for i in range(length(aws_db_instance.replica)) : aws_db_instance.replica[i].endpoint]
}

output "primary_rds_arn" {
  value = aws_db_instance.primary.arn
}

output "db_subnet_group" {
  value = aws_db_subnet_group.your_db_subnet_group_name
}

output "primary_rds_instance_id" {
  value = aws_db_instance.primary.id
}
