module "vpc" {
  source   = "./vpc"
  for_each = var.vpcs

  vpc_name        = each.value.name
  vpc_cidr        = each.value.cidr_block
  vpc_description = "VPC ${each.key} for peering example"
  igw_name        = "${each.value.name}-igw"
}
