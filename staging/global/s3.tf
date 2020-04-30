############################
## S3 objects
############################

locals {
  name = "staging"
  env = "staging"
}


module "bucket" {
  source = "../../modules/s3"
  region = "us-west-2"
  bucket = "${local.name}"

  tags = {
    Terraform   = "true"
    Environment = local.env
  }
}