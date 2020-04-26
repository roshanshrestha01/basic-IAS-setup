############################
## VPC setup
############################

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  name            = var.name
  cidr            = "10.1.0.0/16"
  enable_ipv6     = false
  azs             = ["us-west-2c", "us-west-2a"]
  public_subnets  = ["10.1.0.0/24", "10.1.2.0/24"]
  private_subnets = ["10.1.1.0/24", "10.1.3.0/24"]

  enable_nat_gateway   = true
  enable_vpn_gateway   = true
  enable_dns_hostnames = true

  single_nat_gateway                    = false
  create_database_subnet_route_table    = false
  create_redshift_subnet_route_table    = false
  create_elasticache_subnet_route_table = false


  tags = {
    Terraform   = "true"
    Environment = var.env
  }
}

############################
## Security groups
############################

module "security_groups" {
  source = "./modules/sercurity_groups"
  vpc_id = module.vpc.vpc_id
  name   = var.name

  tags = {
    Terraform   = "true"
    Environment = var.env
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}
