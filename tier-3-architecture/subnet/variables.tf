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
    public_az1 = {
      name                    = "Public-subnet-AZ1"
      cidr_block              = "10.0.101.0/24"
      availability_zone       = "ap-southeast-1a"
      map_public_ip_on_launch = true
    }
    public_az2 = {
      name                    = "Public-subnet-AZ2"
      cidr_block              = "10.0.102.0/24"
      availability_zone       = "ap-southeast-1b"
      map_public_ip_on_launch = true
    }
    app_az1 = {
      name                    = "Private-app-subnet-AZ1"
      cidr_block              = "10.0.1.0/24"
      availability_zone       = "ap-southeast-1a"
      map_public_ip_on_launch = false
    }
    app_az2 = {
      name                    = "Private-app-subnet-AZ2"
      cidr_block              = "10.0.2.0/24"
      availability_zone       = "ap-southeast-1b"
      map_public_ip_on_launch = false
    }
    data_az1 = {
      name                    = "Private-data-subnet-AZ1"
      cidr_block              = "10.0.3.0/24"
      availability_zone       = "ap-southeast-1a"
      map_public_ip_on_launch = false
    }
    data_az2 = {
      name                    = "Private-data-subnet-AZ2"
      cidr_block              = "10.0.4.0/24"
      availability_zone       = "ap-southeast-1b"
      map_public_ip_on_launch = false
    }
  }
}
