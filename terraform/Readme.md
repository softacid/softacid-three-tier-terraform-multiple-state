terraform for a 3-tier network with Postgres rds, fault tolerance, and load balancing using multiple state

Steps:
Make sure you have a S3 bucket for the state that need to be updated in 

 backend "s3" {
    bucket = "tfstate-teodor-homework"
    key    = "network/terraform.tfstate"
    region = "eu-west-1"
    encrypt = true
    use_lockfile = true
  }

/network/main
/compute/main
/data/main



1. cd network
2. terraform init
3. terraform apply
4. cd compute
5. terraform init
6. terraform apply
7. cd data
8. terraform init
9. terraform apply