############################
## Terraform state backup on s3
############################
provider "aws" {}

resource "aws_s3_bucket" "terraform_state_storage_s3" {
  bucket = "terraform-remote-state-management-bucket"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name = "S3 Remote Terraform State Store"
    Terraform = true
  }
}

# create a dynamodb table for locking the state file
resource "aws_dynamodb_table" "dynamodb_terraform_state_lock" {
  name = "terraform-remote-dynamodb-state-lock"
  hash_key = "LockID"
  read_capacity = 20
  write_capacity = 20

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "DynamoDB Terraform State Lock Table"
    Terraform = true
  }
}
