terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket = "tfstate-teodor-homework"
    key    = "compute/terraform.tfstate"
    region = "eu-west-1"
    encrypt = true
    use_lockfile = true
  }
}

provider "aws" {
  region = "eu-west-1"
}


data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = ["three-tier-VPC"]
  }
}

output "vpc_id" {
  value = data.aws_vpc.selected.id
}

data "aws_subnet" "public_subnet" {
  filter {
    name   = "tag:Name"
    values = ["Three-tier-Public-Subnet"]
  }
}

output "public_subnet" {
  value = data.aws_subnet.public_subnet.id
}

data "aws_subnet" "public_subnet_2" {
  filter {
    name   = "tag:Name"
    values = ["Three-tier-Public-Subnet-2"]
  }
}

output "public_subnet_2" {
  value = data.aws_subnet.public_subnet_2.id
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

module "frontend-lb" {
  source = "../modules/compute/Load-Balancer"
  load_balancer_name = "frontend-three-tier-lb-prod"
  internal = false
  load_balancer_type = "application"
  security_groups = [data.aws_security_group.selected.id]
  subnets = [data.aws_subnet.public_subnet.id, data.aws_subnet.public_subnet_2.id]
  Environment = "prod"
  target_group_name = "frontend-lb-tg-prod"
  target_group_port = "80"
  protocol = "HTTP"
  vpc_id  = data.aws_vpc.selected.id
}


module "frontend-ALB" {
  source = "../modules/compute/ASG"
  ami = "ami-03fd334507439f4d1"
  instance_type = "t3.micro"
  key_name = "k8s"
  instance_name = "frontend-prod-instances"
  Environment = "prod"
  security_groups = [data.aws_security_group.selected.id]
  alb_group_name = "three-tier-asg-frontend-prod"
  max_size = 2
  min_size = 1
  desired_capacity = 1
  lb_target_group_arns = [module.frontend-lb.target_group_arn]
  subnets_alb = [data.aws_subnet.public_subnet.id, data.aws_subnet.public_subnet_2.id]
  asg_policy_name = "three-tier-asg-policy-frontend-prod"
  policy_type = "TargetTrackingScaling"
  predefined_metric_type = "ASGAverageCPUUtilization"
  target_value = 50
  health_check_type = "ELB"
}

module "backend-lb" {
  source = "../modules/compute/Load-Balancer"
  load_balancer_name = "backend-three-tier-lb-prod"
  internal = true
  load_balancer_type = "application"
  security_groups = [data.aws_security_group.selected.id]
  subnets = [data.aws_subnet.private_subnet.id, data.aws_subnet.private_subnet_2.id]
  Environment = "prod"
  target_group_name = "backend-lb-tg-prod"
  target_group_port = "80"
  protocol = "HTTP"
  vpc_id = data.aws_vpc.selected.id
}

module "backend-ALB" {
  source = "../modules/compute/ASG"
  ami = "ami-03fd334507439f4d1" //ami-0e2420433e60829b5
  instance_type = "t3.micro"
  key_name = "k8s"
  instance_name = "backend-prod-instances-prod"
  Environment = "prod"
  security_groups = [data.aws_security_group.selected.id]
  alb_group_name = "three-tier-asg-backend-prod"
  max_size = 2
  min_size = 1
  desired_capacity = 1
  lb_target_group_arns = [module.backend-lb.target_group_arn]
  subnets_alb = [data.aws_subnet.private_subnet.id, data.aws_subnet.private_subnet_2.id]
  asg_policy_name = "three-tier-asg-policy-backend-prod"
  policy_type = "TargetTrackingScaling"
  predefined_metric_type = "ASGAverageCPUUtilization"
  target_value = 50
  health_check_type = "ELB"
}