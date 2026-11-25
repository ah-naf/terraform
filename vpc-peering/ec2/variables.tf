variable "key_name" {
  description = "Name of the EC2 key pair created from the local public key"
  type        = string
  default     = "bastion-key"
}

variable "public_key_path" {
  description = "Path to the local SSH public key. Create with: ssh-keygen -t ed25519 -f ~/.ssh/bastion-key"
  type        = string
  default     = "~/.ssh/bastion-key.pub"
}

variable "ami_id" {
  description = "AMI ID for all instances (Ubuntu, ap-southeast-1)"
  type        = string
  default     = "ami-060e277c0d4cce553"
}

variable "instance_type" {
  description = "Default instance type. Override per instance in var.instances"
  type        = string
  default     = "t2.micro"
}

variable "instances" {
  description = "Instances to create, keyed by a short name. Use as for_each source"
  type = map(object({
    name                        = string
    subnet_id                   = string
    security_group_ids          = list(string)
    associate_public_ip_address = optional(bool, false)
    instance_type               = optional(string)
  }))
}
