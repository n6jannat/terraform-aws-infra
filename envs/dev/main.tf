# Dev environment: real AWS. Requires AWS credentials (aws configure) and
# the remote-state bucket created by ../../bootstrap.

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Values come from backend.hcl (copy backend.hcl.example) so no account details live in git:
  #   terraform init -backend-config=backend.hcl
  backend "s3" {}
}

provider "aws" {
  region = var.region

  default_tags {
    tags = local.tags
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  name = "tf-demo-${var.environment}"
  azs  = slice(data.aws_availability_zones.available.names, 0, var.az_count)

  tags = {
    Project     = "terraform-aws-infra"
    Environment = var.environment
    ManagedBy   = "terraform"
    Owner       = var.owner
  }
}

module "vpc" {
  source = "../../modules/vpc"

  name               = local.name
  cidr_block         = var.vpc_cidr
  azs                = local.azs
  enable_nat_gateway = var.enable_nat_gateway
  tags               = local.tags
}

module "web" {
  source = "../../modules/ec2-web"

  name              = local.name
  vpc_id            = module.vpc.vpc_id
  subnet_id         = module.vpc.public_subnet_ids[0]
  instance_type     = var.instance_type
  key_name          = var.key_name
  ssh_allowed_cidrs = var.ssh_allowed_cidrs
  tags              = local.tags
}
