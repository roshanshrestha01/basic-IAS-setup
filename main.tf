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

module "ec2"  {
  source = "./modules/ec2"
  name = "${var.name}-app-100"
  number_of_instances = 1
//  ami = "ami-ebd02392"
  iam_instance_profile = "bats"
  key_name = "devops"
  ami = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  security_groups = [
    module.security_groups.app,
    module.security_groups.ssh,
  ]
  subnets = module.vpc.private_subnets

  tags = {
    Terraform   = "true"
    Environment = var.env
  }
}

module "worker_ec2" {
  source = "./modules/ec2"
  name = "${var.name}-worker-100"
  number_of_instances = 1
  //  ami = "ami-ebd02392"
  iam_instance_profile = "bats"
  key_name = "devops"
  ami = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
  security_groups = [
    module.security_groups.app,
    module.security_groups.ssh,
    module.security_groups.worker
  ]
  subnets = module.vpc.private_subnets

  tags = {
    Terraform   = "true"
    Environment = var.env
  }
}


module "bastion_ec2" {
  source = "./modules/ec2"
  name = "${var.name}-bastion"
  number_of_instances = 1
  //  ami = "ami-ebd02392"
  key_name = "devops"
  ami = data.aws_ami.amazon_linux.id
  iam_instance_profile = "bastion"
  instance_type = "t2.micro"
  security_groups = [
    module.security_groups.app,
    module.security_groups.ssh,
    module.security_groups.all
  ]
  subnets = module.vpc.public_subnets

  tags = {
    Terraform   = "true"
    Environment = var.env
  }
}
//
//resource "aws_eip" "bastion_ec2" {
//  vpc      = true
//  instance = module.bastion_ec2.id
//}
//
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
