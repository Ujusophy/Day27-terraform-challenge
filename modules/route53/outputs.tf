output "primary_dns" {
  value = aws_route53_record.primary.fqdn
}

output "secondary_dns" {
  value = aws_route53_record.secondary.fqdn
}
