variable "vpc_id" {
  description = "ID of the VPC the security group belongs to"
  type        = string
}

variable "name" {
  description = "Name of the security group"
  type        = string
}

variable "description" {
  description = "Description of the security group"
  type        = string
  default     = "Managed by Terraform"
}

variable "ingress_rules" {
  description = <<-EOT
    Ingress rules keyed by a short name. Set either cidr_ipv4 or referenced_security_group_id per rule.
    ip_protocol defaults to tcp. Use "-1" for all protocols (ports then ignored).
  EOT
  type = map(object({
    description                  = optional(string)
    ip_protocol                  = optional(string, "tcp")
    from_port                    = optional(number)
    to_port                      = optional(number)
    cidr_ipv4                    = optional(string)
    referenced_security_group_id = optional(string)
  }))
  default = {}
}

variable "allow_all_egress" {
  description = "Allow all outbound traffic"
  type        = bool
  default     = true
}
