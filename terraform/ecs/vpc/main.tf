locals {
  cidr            = "10.0.0.0/16"
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.3.0/24", "10.0.4.0/24"]
  intra_subnets   = ["10.0.5.0/24", "10.0.6.0/24"]
}


module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.12.0"

  name = var.vpc_name
  cidr = local.cidr

  azs             = var.azs
  private_subnets = local.private_subnets
  public_subnets  = local.public_subnets
  intra_subnets   = local.intra_subnets

  enable_nat_gateway = true
  create_igw         = true

  enable_dns_hostnames = true
  enable_dns_support   = true

  igw_tags = var.tags
  tags     = var.tags
}
