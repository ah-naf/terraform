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
    Route tables to create, keyed by a short name.
    subnet_key is a key of var.subnet_ids to associate.
    routes is a list of routes. Per route, set cidr_block and exactly one target:
    gateway_id (internet gateway), nat_gateway_id, or vpc_peering_connection_id.
    The local VPC route is added by AWS and is not listed here.
  EOT
  type = map(object({
    name       = string
    subnet_key = string
    routes = optional(list(object({
      cidr_block                = string
      gateway_id                = optional(string)
      nat_gateway_id            = optional(string)
      vpc_peering_connection_id = optional(string)
    })), [])
  }))
}
