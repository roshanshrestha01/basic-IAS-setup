data "aws_iam_policy_document" "policy" {
  version = "2012-10-17"
  statement {
    sid = "PublicReadGetObject"
    effect = "Allow"
    actions = [
      "s3:GetObject",
    ]

    principals {
      identifiers = ["*"]
      type = "*"
    }

    resources = [
      "arn:aws:s3:::${var.bucket}/*",
    ]
  }
}

resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.bucket
  acl    = "private"
  //  policy = data.aws_iam_policy_document.policy.json

  versioning {
    enabled = true
  }

  tags = var.tags
}