variable "subnet_group_name" {
  description = "Subnet group name"
  type = string
}

variable "subnet_ids" {
    description = "Subnet ids list"
    type = list(string)
}

variable "allocated_storage" {
  description = "allocated_storage"
  type = number
}

variable "rds_password" {
  description = "RDS password retrieved from Secrets Manager"
  type        = string
  sensitive   = true
}

variable "db_name" {
    description = "db_name"
    type = string
}

variable "db_engine" {
    description = "db_engine"
    type = string
}

variable "db_engine_version" {
  description = "db_engine_version"
  type = string
}

variable "instance_type" {
  description = "instance_type"
  type = string
}

variable "rds_username" {
  description = "rds_username"
  type = string
}



variable "skip_final_snapshot" {
  type = bool
}

variable "security_group_ids" {
  type = list(string)
}

variable "Environment" {
  type = string
}

variable "identifier" {
  description = "rds name"
  type = string
}

variable "identifier_replica" {
  description = "name of rds replica instance"
  type = string
}

variable "backup_retention_period" {
  type = number
}