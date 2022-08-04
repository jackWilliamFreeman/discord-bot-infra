terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"

    }
  }

  backend "s3" {
    bucket         = "ecs-terraform-remote-state-s3-discord-bots"
    key            = "discord.bot.infra"
    region         = "ap-southeast-2"
    encrypt        = "true"
    dynamodb_table = "ecs-terraform-remote-state-dynamodb"
  }
}

provider "aws" {
  region     = var.aws_region
}


locals {
  aws_region = "ap-southeast-2"
  prefix     = "Terraform-discord-infra"
  common_tags = {
    Project   = local.prefix
    ManagedBy = "Terraform"
  }
  vpc_cidr = var.vpc_cidr
  id = 301687741300
}

module "ecs_vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${local.prefix}-vpc"
  cidr = local.vpc_cidr

  azs             = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_nat_gateway     = true
  enable_dns_hostnames   = true
  one_nat_gateway_per_az = true

  tags = local.common_tags
}
