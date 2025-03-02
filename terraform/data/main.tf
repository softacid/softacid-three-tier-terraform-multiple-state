terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket = "tfstate-teodor-homework"
    key    = "data/terraform.tfstate"
    region = "eu-west-1"
    encrypt = true
    use_lockfile = true
  }
}

provider "aws" {
  region = "eu-west-1"
}

data "aws_subnet" "private_subnet" {
  filter {
    name   = "tag:Name"
    values = ["Three-tier-Private-subnet"]
  }
}

output "private_subnet" {
  value = data.aws_subnet.private_subnet.id
}

data "aws_subnet" "private_subnet_2" {
  filter {
    name   = "tag:Name"
    values = ["Three-tier-Private-subnet-2"]
  }
}

output "private_subnet_2" {
  value = data.aws_subnet.private_subnet_2.id
}

data "aws_security_group" "selected" {
  filter {
    name   = "tag:Name"
    values = ["test-sg"]
  }
}

output "security_group_id" {
  value = data.aws_security_group.selected.id
}


module "rds" {
  source                   = "../modules/data/RDS"
  identifier               = "three-tier-db-dev"
  allocated_storage        = 10
  db_name                  = "ThreeTierDb"
  db_engine                = "postgres"
  db_engine_version        = "16"
  instance_type            = "db.t3.micro"
  subnet_group_name        = "three-tier-subnet-group"
  subnet_ids               = [data.aws_subnet.private_subnet.id, data.aws_subnet.private_subnet_2.id]
  skip_final_snapshot      = true
  security_group_ids       = [data.aws_security_group.selected.id]
  Environment              = "dev"
  rds_username            = "teo"
  rds_password            = "Password123"
  identifier_replica       = "three-tier-db-dev-replica"
  backup_retention_period  = 7
}