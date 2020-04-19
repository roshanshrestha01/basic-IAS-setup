variable "name" {
  description = "Subnets for database"
  default     = "db"
}

variable "subnets" {
  description = "Subnets for database"
  default     = []
}

variable "vpc_id" {
  description = "VPC id"
}

variable "security_groups" {
  description = "Security groups for db"
}

variable "cidr_blocks" {
  description = "CIDR blocks for db"
}

variable "instance_type" {
  description = "Instance type blocks for db"
}

variable "tags" {
  description = "default tags"
}