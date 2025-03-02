terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket = "tfstate-teodor-homework"
    key    = "network/terraform.tfstate"
    region = "eu-west-1"
    encrypt = true
    use_lockfile = true
  }
}

provider "aws" {
  region = "eu-west-1"
}

module "sg" {
  source      = "../modules/network/Security_groups"
  vpc_id      = module.vpc.vpc_id
  name        = "test-sg"
  description = "a test sg"

  ingress_rules = [
    {
      description = "HTTP Port"
      from_port   = "80"
      to_port     = "80"
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "SSH Port"
      from_port   = "22"
      to_port     = "22"
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "MYSQL Port"
      from_port   = "3306"
      to_port     = "3306"
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "Backend Port"
      from_port   = "3000"
      to_port     = "3000"
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
  egress_rules = [
    {
      description = "Allow all outbound traffic"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

module "vpc" {
  source                          = "../modules/network/VPC"
  vpc_cidr                        = "10.0.0.0/16"
  vpc_name                        = "three-tier-VPC"
  public_subnet_cidr_block        = "10.0.0.0/24"
  public_subnet_name              = "Three-tier-Public-Subnet"
  public_sub_availability_zone    = "eu-west-1a"
  private_subnet_cidr_block       = "10.0.1.0/24"
  private_subnet_name             = "Three-tier-Private-subnet"
  private_sub_availability_zone   = "eu-west-1b"
  public_subnet_cidr_block_2      = "10.0.2.0/24"
  public_subnet_name_2            = "Three-tier-Public-Subnet-2"
  public_sub_availability_zone_2  = "eu-west-1b"
  private_subnet_cidr_block_2     = "10.0.3.0/24"
  private_subnet_name_2           = "Three-tier-Private-subnet-2"
  private_sub_availability_zone_2 = "eu-west-1a"
}
