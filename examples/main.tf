# Be sure to set appropriate AWS CLI credentials via the environment.
provider "aws" {}

data "aws_availability_zones" "this" {
  state = "available"
}

locals {
  azs  = slice(data.aws_availability_zones.this.zone_ids, 0, 3)
  cidr = "10.4.20.0/22"
}

module "subnets" {
  source = "../"

  maximum_subnet_mask_bits = 28
  network_cidr             = local.cidr
  subdivisions             = length(local.azs)
  subnet_types_ratio       = "5:2"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "terraform-cidrsubnets-ratios-example"
  cidr = local.cidr

  azs             = local.azs
  private_subnets = module.subnets.subnets[0]
  public_subnets  = module.subnets.subnets[1]

  enable_nat_gateway = false

  tags = {
    Terraform = "true"
    Module    = "terraform-cidrsubnets-ratios/example"
    Name      = "terraform-cidrsubnets-ratios-example"
  }
}
