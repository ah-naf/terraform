variable "subnet_id" {
  description = "ID of the public subnet to place the NAT gateway in"
  type        = string
}

variable "nat_name" {
  description = "Name tag of the NAT gateway"
  type        = string
  default     = "my-nat"
}

variable "eip_name" {
  description = "Name tag of the Elastic IP used by the NAT gateway"
  type        = string
  default     = "my-nat-eip"
}
