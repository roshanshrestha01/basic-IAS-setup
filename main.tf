module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "accounting-box-vpc-staging"
  cidr = "10.1.0.0/16"
  enable_ipv6 = false
  azs             = ["us-west-2"]
  public_subnets  = ["10.1.0.0/24"]
  private_subnets = ["10.1.1.0/24"]
  
  enable_nat_gateway = true
  single_nat_gateway = false
  enable_vpn_gateway = true

  create_database_subnet_route_table=false
  create_redshift_subnet_route_table=false
  create_elasticache_subnet_route_table=false
  

  tags = {
    Terraform = "true"
    Environment = "staging"
  }
}