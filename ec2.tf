############################
## EC2 intances
############################

module "bastion_ec2" {
  source = "./modules/ec2"
  name = "${var.name}-bastion"
  number_of_instances = 1
  //  ami = "ami-ebd02392"
  key_name = "devops"
  ami = data.aws_ami.ubuntu.id
  iam_instance_profile = "bastion"
  instance_type = "t2.micro"
  security_groups = [
    module.security_groups.app,
    module.security_groups.ssh,
    module.security_groups.all
  ]
  subnets = module.vpc.public_subnets
  user_data = file("./install.sh")

  tags = {
    Terraform   = "true"
    Environment = var.env
  }
}

module "ec2"  {
  source = "./modules/ec2"
  name = "${var.name}-app-100"
  number_of_instances = 1
  //  ami = "ami-ebd02392" # Replace with custom AMI if present
  iam_instance_profile = "bats" # Replace IAM user
  key_name = "devops" # Replace key name
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
    env = var.env
    role = "app"
  }
}

module "node"  {
  source = "./modules/ec2"
  name = "${var.name}-node-100"
  number_of_instances = 1
  //  ami = "ami-ebd02392" # Replace with custom AMI if present
  iam_instance_profile = "bats" # Replace IAM user
  key_name = "devops" # Replace key name
  ami = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  security_groups = [
    module.security_groups.app,
    module.security_groups.tcp_9900,
    module.security_groups.ssh,
  ]
  subnets = module.vpc.private_subnets

  tags = {
    Terraform   = "true"
    Environment = var.env
    env = var.env
    role = "app"
  }
}

module "worker_ec2" {
  source = "./modules/ec2"
  name = "${var.name}-worker-100"
  number_of_instances = 1
  //  ami = "ami-ebd02392"
  iam_instance_profile = "bats"
  key_name = "devops"
  ami = data.aws_ami.ubuntu.id
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

module "go_server_ec2" {
  source = "./modules/ec2"
  name = "${var.name}-factory-server-100"
  number_of_instances = 1
  //  ami = "ami-ebd02392"
  iam_instance_profile = "bats"
  key_name = "devops"
  ami = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  security_groups = [
    module.security_groups.ssh,
    module.security_groups.factory_server
  ]
  subnets = module.vpc.public_subnets

  tags = {
    Terraform   = "true"
    Environment = var.env
  }
}

module "go_client_ec2" {
  source = "./modules/ec2"
  name = "${var.name}-factory-worker-100"
  number_of_instances = 1
  //  ami = "ami-ebd02392"
  iam_instance_profile = "bats"
  key_name = "devops"
  ami = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  security_groups = [
    module.security_groups.tcp_9900,
    module.security_groups.ssh,
  ]
  subnets = module.vpc.private_subnets

  tags = {
    Terraform   = "true"
    Environment = var.env
  }
}

 Uncomment to assign elastic ip to bastion

resource "aws_eip" "bastion_ec2" {
  vpc      = true
  instance = module.bastion_ec2.id[0]
}