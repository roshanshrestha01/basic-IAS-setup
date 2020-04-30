############################
## S3 objects
############################

locals {
  name = "staging"
  env = "staging"
}


module "zenledger_gua" {
  source = "../../modules/s3"
  region = "us-west-2"
  bucket = "${local.name}-zenledger-gua"

  tags = {
    Terraform   = "true"
    Environment = local.env
  }
}

module "admin_metric_data" {
  source = "../../modules/s3"
  region = "us-west-2"
  bucket = "${local.name}-admin-metric-data"

  tags = {
    Terraform   = "true"
    Environment = local.env
  }
}

module "zenledger_pdf" {
  source = "../../modules/s3"
  region = "us-west-2"
  bucket = "${local.name}-zenledger-pdf"

  tags = {
    Terraform   = "true"
    Environment = local.env
  }
}

module "admin_subpoena_files" {
  source = "../../modules/s3"
  region = "us-west-2"
  bucket = "${local.name}-admin-subpoena-files"

  tags = {
    Terraform   = "true"
    Environment = local.env
  }
}

module "zenledger_csv" {
  source = "../../modules/s3"
  region = "us-west-2"
  bucket = "${local.name}-zenledger-csv"

  tags = {
    Terraform   = "true"
    Environment = local.env
  }
}
