module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name            = var.name
  cidr            = "10.1.0.0/16"
  enable_ipv6     = false
  azs             = ["us-west-2a", "us-west-2c"]
  public_subnets  = ["10.1.0.0/24"]
  private_subnets = ["10.1.1.0/24"]

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

module "security_groups" {
  source = "./modules/sercurity_groups"
  vpc_id = module.vpc.vpc_id
  name   = var.name

  tags = {
    Terraform   = "true"
    Environment = var.env
  }
}


module "db" {
  source = "./modules/db"
  name = var.name
  vpc_id = module.vpc.vpc_id
  subnets = concat(module.vpc.private_subnets, ["subnet-089a7b1fc83e88e79"])
  security_groups = [module.security_groups.postgres]
  cidr_blocks = ["10.1.0.0/16"]
  instance_type = "db.t2.micro"

  tags = {
    Terraform   = "true"
    Environment = var.env
  }
}
