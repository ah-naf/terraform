output "nat_gateway_id" {
  description = "ID of the NAT gateway"
  value       = aws_nat_gateway.this.id
}

output "nat_public_ip" {
  description = "Public IP (Elastic IP) of the NAT gateway"
  value       = aws_eip.this.public_ip
}
