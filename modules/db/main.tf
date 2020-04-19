provider "aws" {}

#############
# RDS Aurora
#############
module "aurora" {
  source                          = "terraform-aws-modules/rds-aurora/aws"
  create_security_group  = false
  name                            = "${var.name}-aurora-postgresql"
  engine                          = "aurora-postgresql"
  engine_version                  = "9.6.12"
  subnets                         = var.subnets
  allowed_security_groups         = var.security_groups
  vpc_security_group_ids          = var.security_groups

  allowed_cidr_blocks             = var.cidr_blocks
  vpc_id                          = var.vpc_id
  replica_count                   = 1
  instance_type                   = var.instance_type
  apply_immediately               = true
  skip_final_snapshot             = true
//  db_parameter_group_name         = "${aws_db_parameter_group.roshan.id}"
//  db_cluster_parameter_group_name = "${aws_rds_cluster_parameter_group.aurora-cluster-postgres9-parameter-group.id}"
  //  enabled_cloudwatch_logs_exports = ["audit", "error", "general", "slowquery"]

  tags = merge(
  {
    Name: "${var.name}-aurora-postgresql"
  },
  var.tags
  )

}
//
//resource "aws_db_parameter_group" "roshan" {
//  name        = "aurora-db-postgres9.6.12-parameter-group"
//  family      = "${var.name}-aurora-postgresql9.6.12"
//  description = "${var.name}-aurora-db-postgres9.6.12-parameter-group"
//
//  tags = merge(
//  {
//    Name: "${var.name}-aurora-postgresql"
//  },
//  var.tags
//  )
//}
//
//resource "aws_rds_cluster_parameter_group" "aurora-cluster-postgres9-parameter-group" {
//  name        = "${var.name}-aurora-postgres9.6.12-cluster-parameter-group"
//  family      = "${var.name}-aurora-postgresql9.6.12"
//  description = "${var.name}-aurora-postgres9.6.12-cluster-parameter-group"
//
//  tags = merge(
//  {
//    Name: "${var.name}-aurora-postgres9.6.12-cluster-parameter-group"
//  },
//  var.tags
//  )
//}
