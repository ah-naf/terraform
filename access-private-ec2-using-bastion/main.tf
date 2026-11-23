module "vpc" {
  source = "./vpc"
}

module "subnet" {
  source = "./subnet"
  vpc_id = module.vpc.vpc_id
}

module "nat_gateway" {
  source    = "./nat_gateway"
  subnet_id = module.subnet.subnet_ids["public"]

  # NAT needs the internet gateway attached first
  depends_on = [module.vpc]
}

module "route_table" {
  source     = "./route_table"
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.subnet.subnet_ids

  route_tables = {
    public = {
      name       = "public-rt"
      subnet_key = "public"
      gateway_id = module.vpc.igw_id
    }
    private = {
      name           = "private-rt"
      subnet_key     = "private"
      nat_gateway_id = module.nat_gateway.nat_gateway_id
    }
  }
}

module "bastion_sg" {
  source = "./security_group"
  vpc_id = module.vpc.vpc_id
  name   = "bastion-sg"

  ingress_rules = {
    ssh = {
      description = "SSH from allowed CIDR"
      from_port   = 22
      to_port     = 22
      cidr_ipv4   = var.allowed_ssh_cidr
    }
  }
}

module "private_sg" {
  source = "./security_group"
  vpc_id = module.vpc.vpc_id
  name   = "private-sg"

  ingress_rules = {
    ssh_from_bastion = {
      description                  = "SSH from bastion"
      from_port                    = 22
      to_port                      = 22
      referenced_security_group_id = module.bastion_sg.sg_id
    }
  }
}

module "ec2" {
  source          = "./ec2"
  public_key_path = "${path.root}/bastion-key.pub"

  instances = {
    bastion = {
      name                        = "bastion"
      subnet_id                   = module.subnet.subnet_ids["public"]
      security_group_ids          = [module.bastion_sg.sg_id]
      associate_public_ip_address = true
    }
    private = {
      name               = "private-ec2"
      subnet_id          = module.subnet.subnet_ids["private"]
      security_group_ids = [module.private_sg.sg_id]
    }
  }
}
