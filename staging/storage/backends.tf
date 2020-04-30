terraform {
  backend "s3" {
    encrypt = true
    bucket = "terraform-remote-state-management-bucket"
    dynamodb_table = "terraform-remote-dynamodb-state-lock"
    region = "us-west-2"
    key = "staging/storage/terraform.tfstate" # path to store state Eg /app/staging/terraform.tfstate
  }
}