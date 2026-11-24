module "vpc" {
  source = "./vpc"
}

module "subnet" {
  source = "./subnet"
  vpc_id = module.vpc.vpc_id
}

# One NAT gateway per AZ, each in its own public subnet
module "nat_gateway" {
  source   = "./nat_gateway"
  for_each = toset(["az1", "az2"])

  subnet_id = module.subnet.subnet_ids["public_${each.key}"]
  nat_name  = "NAT-GW-${upper(each.key)}"
  eip_name  = "NAT-EIP-${upper(each.key)}"

  # NAT needs the internet gateway attached first
  depends_on = [module.vpc]
}

module "route_table" {
  source     = "./route_table"
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.subnet.subnet_ids

  route_tables = {
    public = {
      name       = "Public-RT"
      gateway_id = module.vpc.igw_id
    }
    private_az1 = {
      name           = "Private-RT-AZ1"
      nat_gateway_id = module.nat_gateway["az1"].nat_gateway_id
    }
    private_az2 = {
      name           = "Private-RT-AZ2"
      nat_gateway_id = module.nat_gateway["az2"].nat_gateway_id
    }
  }

  # subnet key = route table key
  subnet_associations = {
    public_az1 = "public"
    public_az2 = "public"
    app_az1    = "private_az1"
    data_az1   = "private_az1"
    app_az2    = "private_az2"
    data_az2   = "private_az2"
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
      subnet_id                   = module.subnet.subnet_ids["public_az1"]
      security_group_ids          = [module.bastion_sg.sg_id]
      associate_public_ip_address = true
    }
    private = {
      name               = "private-ec2"
      subnet_id          = module.subnet.subnet_ids["app_az1"]
      security_group_ids = [module.private_sg.sg_id]
    }
  }
}
