output "bastion_public_ip" {
  description = "Public IP of the bastion host"
  value       = module.ec2.public_ips["bastion"]
}

output "private_instance_ip" {
  description = "Private IP of the private instance"
  value       = module.ec2.private_ips["private"]
}

output "nat_public_ip" {
  description = "Public IP the private instance uses for outbound traffic"
  value       = module.nat_gateway.nat_public_ip
}

output "ssh_bastion" {
  description = "Command to SSH into the bastion"
  value       = "ssh -i ${path.root}/bastion-key ubuntu@${module.ec2.public_ips["bastion"]}"
}

output "ssh_private" {
  description = "Command to SSH into the private instance through the bastion"
  value       = "ssh -i ${path.root}/bastion-key -J ubuntu@${module.ec2.public_ips["bastion"]} ubuntu@${module.ec2.private_ips["private"]}"
}
