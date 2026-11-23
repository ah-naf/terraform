variable "vpc_id" {
  description = "ID of the VPC the subnets belong to"
  type        = string
}

variable "subnets" {
  description = "Subnets to create, keyed by a short name. Use as for_each source"
  type = map(object({
    name                    = string
    cidr_block              = string
    availability_zone       = string
    map_public_ip_on_launch = bool
  }))
  default = {
    public = {
      name                    = "public-subnet"
      cidr_block              = "10.0.1.0/24"
      availability_zone       = "ap-southeast-1a"
      map_public_ip_on_launch = true
    }
    private = {
      name                    = "private-subnet"
      cidr_block              = "10.0.2.0/24"
      availability_zone       = "ap-southeast-1a"
      map_public_ip_on_launch = false
    }
  }
}
