variable "vpc_id" {
  description = "ID of the VPC the route tables belong to"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs keyed by short name. Pass module.subnet.subnet_ids"
  type        = map(string)
}

variable "route_tables" {
  description = <<-EOT
    Route tables to create, keyed by a short name. Each gets one default route (0.0.0.0/0).
    Set gateway_id for an internet gateway, or nat_gateway_id for a NAT gateway.
    subnet_key is a key of var.subnet_ids to associate.
  EOT
  type = map(object({
    name           = string
    subnet_key     = string
    gateway_id     = optional(string)
    nat_gateway_id = optional(string)
  }))
}
