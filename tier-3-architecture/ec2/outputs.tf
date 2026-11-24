output "instance_ids" {
  description = "Instance IDs, keyed like var.instances"
  value       = { for k, i in aws_instance.this : k => i.id }
}

output "public_ips" {
  description = "Public IPs, keyed like var.instances. Null for instances without a public IP"
  value       = { for k, i in aws_instance.this : k => i.public_ip }
}

output "private_ips" {
  description = "Private IPs, keyed like var.instances"
  value       = { for k, i in aws_instance.this : k => i.private_ip }
}

output "key_name" {
  description = "Name of the EC2 key pair"
  value       = aws_key_pair.this.key_name
}
