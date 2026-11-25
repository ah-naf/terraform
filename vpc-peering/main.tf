module "vpc" {
  source   = "./vpc"
  for_each = var.vpcs

  vpc_name        = each.value.name
  vpc_cidr        = each.value.cidr_block
  vpc_description = "VPC ${each.key} for peering example"
  igw_name        = "${each.value.name}-igw"
}

# Public subnet in VPC a
module "subnet_a" {
  source = "./subnet"
  vpc_id = module.vpc["a"].vpc_id

  subnets = {
    public = {
      name                    = "vpc-a-public-subnet"
      cidr_block              = "10.0.1.0/24"
      availability_zone       = "ap-southeast-1a"
      map_public_ip_on_launch = true
    }
  }
}

# Private subnet in VPC b
module "subnet_b" {
  source = "./subnet"
  vpc_id = module.vpc["b"].vpc_id

  subnets = {
    private = {
      name                    = "vpc-b-private-subnet"
      cidr_block              = "10.1.1.0/24"
      availability_zone       = "ap-southeast-1a"
      map_public_ip_on_launch = false
    }
  }
}

# Bastion in VPC a: SSH from your IP only
module "bastion_sg" {
  source = "./security_group"
  vpc_id = module.vpc["a"].vpc_id
  name   = "vpc-a-bastion-sg"

  ingress_rules = {
    ssh = {
      description = "SSH from allowed CIDR"
      from_port   = 22
      to_port     = 22
      cidr_ipv4   = var.allowed_ssh_cidr
    }
  }
}

# Private instance in VPC b: SSH and ping from VPC a over the peering connection.
# Uses the VPC a CIDR, not the bastion security group, so it does not depend on
# the peering connection already existing.
module "private_sg" {
  source = "./security_group"
  vpc_id = module.vpc["b"].vpc_id
  name   = "vpc-b-private-sg"

  ingress_rules = {
    ssh_from_vpc_a = {
      description = "SSH from VPC a"
      from_port   = 22
      to_port     = 22
      cidr_ipv4   = var.vpcs["a"].cidr_block
    }
    icmp_from_vpc_a = {
      description = "Ping from VPC a"
      ip_protocol = "icmp"
      from_port   = -1
      to_port     = -1
      cidr_ipv4   = var.vpcs["a"].cidr_block
    }
  }
}
