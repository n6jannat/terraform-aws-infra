# Local environment: runs against LocalStack (fake AWS in Docker) — no AWS account, no cost.
# Start LocalStack first:  docker compose up -d   (from the repo root)

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region     = var.region
  access_key = "test"
  secret_key = "test"

  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
  s3_use_path_style           = true

  endpoints {
    ec2 = var.localstack_endpoint
    s3  = var.localstack_endpoint
    sts = var.localstack_endpoint
    iam = var.localstack_endpoint
  }

  default_tags {
    tags = local.tags
  }
}

locals {
  name = "tf-demo-local"
  tags = {
    Project     = "terraform-aws-infra"
    Environment = "local"
    ManagedBy   = "terraform"
  }
}

module "vpc" {
  source = "../../modules/vpc"

  name       = local.name
  cidr_block = "10.10.0.0/16"
  azs        = ["${var.region}a", "${var.region}b"]
  tags       = local.tags
}

module "web" {
  source = "../../modules/ec2-web"

  name      = local.name
  vpc_id    = module.vpc.vpc_id
  subnet_id = module.vpc.public_subnet_ids[0]
  tags      = local.tags

  # LocalStack's mock image catalogue has Amazon Linux 2, not AL2023
  ami_name_filter = "amzn2-ami-hvm-*-x86_64-gp2"
}
