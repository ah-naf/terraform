output "subnet_ids" {
  description = "Subnet IDs, keyed like var.subnets"
  value       = { for k, s in aws_subnet.this : k => s.id }
}

output "subnet_cidrs" {
  description = "Subnet CIDR blocks, keyed like var.subnets"
  value       = { for k, s in aws_subnet.this : k => s.cidr_block }
}

output "subnet_azs" {
  description = "Subnet availability zones, keyed like var.subnets"
  value       = { for k, s in aws_subnet.this : k => s.availability_zone }
}
