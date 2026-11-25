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
      availability_zone       = "us-east-1a"
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
      availability_zone       = "us-east-1a"
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
    icmp_from_vpc_b = {
      description = "Ping from VPC b"
      ip_protocol = "icmp"
      from_port   = -1
      to_port     = -1
      cidr_ipv4   = var.vpcs["b"].cidr_block
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

# Peering between VPC a (requester) and VPC b (accepter).
# Same account and region, so auto_accept works.
resource "aws_vpc_peering_connection" "this" {
  vpc_id      = module.vpc["a"].vpc_id
  peer_vpc_id = module.vpc["b"].vpc_id
  auto_accept = true

  tags = {
    Name = "vpc-a-to-vpc-b"
  }
}

# VPC a: public route table, internet through the IGW, VPC b through peering
module "route_table_a" {
  source     = "./route_table"
  vpc_id     = module.vpc["a"].vpc_id
  subnet_ids = module.subnet_a.subnet_ids

  route_tables = {
    public = {
      name       = "vpc-a-public-rt"
      subnet_key = "public"
      routes = [
        { cidr_block = "0.0.0.0/0", gateway_id = module.vpc["a"].igw_id },
        { cidr_block = var.vpcs["b"].cidr_block, vpc_peering_connection_id = aws_vpc_peering_connection.this.id }
      ]
    }
  }
}

# VPC b: private route table, VPC a through peering (return path for replies)
module "route_table_b" {
  source     = "./route_table"
  vpc_id     = module.vpc["b"].vpc_id
  subnet_ids = module.subnet_b.subnet_ids

  route_tables = {
    private = {
      name       = "vpc-b-private-rt"
      subnet_key = "private"
      routes = [
        { cidr_block = var.vpcs["a"].cidr_block, vpc_peering_connection_id = aws_vpc_peering_connection.this.id }
      ]
    }
  }
}

# One module call creates the key pair once and both instances.
# Each instance lands in its own VPC, chosen by its subnet.
module "ec2" {
  source          = "./ec2"
  public_key_path = "${path.root}/bastion-key.pub"

  instances = {
    bastion = {
      name                        = "vpc-a-bastion"
      subnet_id                   = module.subnet_a.subnet_ids["public"]
      security_group_ids          = [module.bastion_sg.sg_id]
      associate_public_ip_address = true
    }
    private = {
      name               = "vpc-b-private"
      subnet_id          = module.subnet_b.subnet_ids["private"]
      security_group_ids = [module.private_sg.sg_id]
    }
  }
}
