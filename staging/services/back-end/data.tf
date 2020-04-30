data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "terraform-remote-state-management-bucket"
    key    = "staging/vpc/terraform.tfstate"
  }
}