############################
## S3 objects
############################

module "zenledger_gua" {
  source = "./modules/s3"
  region = "us-west-2"
  bucket = "${var.name}-zenledger-gua"

  tags = {
    Terraform   = "true"
    Environment = var.env
  }
}

module "admin_metric_data" {
  source = "./modules/s3"
  region = "us-west-2"
  bucket = "${var.name}-admin-metric-data"

  tags = {
    Terraform   = "true"
    Environment = var.env
  }
}

module "zenledger_pdf" {
  source = "./modules/s3"
  region = "us-west-2"
  bucket = "${var.name}-zenledger-pdf"

  tags = {
    Terraform   = "true"
    Environment = var.env
  }
}

module "admin_subpoena_files" {
  source = "./modules/s3"
  region = "us-west-2"
  bucket = "${var.name}-admin-subpoena-files"

  tags = {
    Terraform   = "true"
    Environment = var.env
  }
}

module "zenledger_csv" {
  source = "./modules/s3"
  region = "us-west-2"
  bucket = "${var.name}-zenledger-csv"

  tags = {
    Terraform   = "true"
    Environment = var.env
  }
}
