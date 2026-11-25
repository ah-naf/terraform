variable "vpcs" {
  description = "VPCs to create, keyed by a short name. CIDRs must not overlap, or peering is impossible"
  type = map(object({
    name       = string
    cidr_block = string
  }))
  default = {
    a = {
      name       = "vpc-a"
      cidr_block = "10.0.0.0/16"
    }
    b = {
      name       = "vpc-b"
      cidr_block = "10.1.0.0/16"
    }
  }
}
