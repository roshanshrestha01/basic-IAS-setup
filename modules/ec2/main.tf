module "ec2_instances" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 2.0"

  instance_count = var.number_of_instances

  name                        = var.name
  ami                         = var.ami
  instance_type               = var.instance_type
  vpc_security_group_ids      = var.security_groups
  subnet_ids                   = var.subnets
  iam_instance_profile = var.iam_instance_profile
  key_name = var.key_name

  tags = merge(
  {
    "Name" = var.name
  },
  var.tags,
  )
}