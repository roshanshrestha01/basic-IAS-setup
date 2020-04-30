############################
## Database aurara setup
############################

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "terraform-remote-state-management-bucket"
    key    = "staging/vpc/terraform.tfstate"
  }
}

module "db" {
  source = "../../modules/db"
  name = "staging-database"
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
  subnets = data.terraform_remote_state.vpc.outputs.private_subnets
  security_groups = [data.terraform_remote_state.vpc.outputs.sg_postgres]
  cidr_blocks = ["10.1.0.0/16"]
  instance_type = "db.r4.large"

  tags = {
    Terraform   = "true"
    Environment = "staging"
  }
}

