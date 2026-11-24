variable "allowed_ssh_cidr" {
  description = "CIDR allowed to SSH into the bastion, e.g. your public IP as 203.0.113.5/32. Find it with: curl -s ifconfig.me"
  type        = string
}
