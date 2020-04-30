############################
## VPC setup
############################

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  name            = "staging"
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
    Environment = "staging"
  }
}