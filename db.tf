############################
## Database aurara setup
############################

//module "db" {
//  source = "./modules/db"
//  name = var.name
//  vpc_id = module.vpc.vpc_id
//  subnets = module.vpc.private_subnets
//  security_groups = [module.security_groups.postgres]
//  cidr_blocks = ["10.1.0.0/16"]
//  instance_type = "db.r4.large"
//
//  tags = {
//    Terraform   = "true"
//    Environment = var.env
//  }
//}

