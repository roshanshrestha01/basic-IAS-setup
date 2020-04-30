############################
## EC2 intances
############################
locals {
  name = "staging"
  env = "staging"
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
  source = "../../../modules/ec2"
  name = "${local.name}-app-100"
  number_of_instances = 1
  //  ami = "ami-ebd02392" # Replace with custom AMI if present
  iam_instance_profile = "bats" # Replace IAM user
  key_name = "devops" # Replace key name
  ami = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  security_groups = [
    data.terraform_remote_state.vpc.outputs.sg_app,
    data.terraform_remote_state.vpc.outputs.sg_ssh,
  ]
  subnets = data.terraform_remote_state.vpc.outputs.private_subnets
  user_data = file("./install.sh")

  tags = {
    Terraform   = "true"
    Environment = local.env
    env = local.env
    role = "app"
  }
}

module "node"  {
  source = "../../../modules/ec2"
  name = "${local.name}-node-100"
  number_of_instances = 1
  //  ami = "ami-ebd02392" # Replace with custom AMI if present
  iam_instance_profile = "bats" # Replace IAM user
  key_name = "devops" # Replace key name
  ami = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  security_groups = [
    data.terraform_remote_state.vpc.outputs.sg_app,
    data.terraform_remote_state.vpc.outputs.sg_ssh,
    data.terraform_remote_state.vpc.outputs.sg_tcp_9900,
  ]
  subnets = data.terraform_remote_state.vpc.outputs.private_subnets
  user_data = file("./install.sh")

  tags = {
    Terraform   = "true"
    Environment = local.env
    env = local.env
    role = "app"
  }
}

module "worker_ec2" {
  source = "../../../modules/ec2"
  name = "${local.name}-worker-100"
  number_of_instances = 1
  //  ami = "ami-ebd02392"
  iam_instance_profile = "bats"
  key_name = "devops"
  ami = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  security_groups = [
    data.terraform_remote_state.vpc.outputs.sg_app,
    data.terraform_remote_state.vpc.outputs.sg_ssh,
    data.terraform_remote_state.vpc.outputs.sg_worker,
  ]
  subnets = data.terraform_remote_state.vpc.outputs.private_subnets
  user_data = file("./install.sh")

  tags = {
    Terraform   = "true"
    Environment = local.env
  }
}

module "go_server_ec2" {
  source = "../../../modules/ec2"
  name = "${local.name}-factory-server-100"
  number_of_instances = 1
  //  ami = "ami-ebd02392"
  iam_instance_profile = "bats"
  key_name = "devops"
  ami = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  security_groups = [
    data.terraform_remote_state.vpc.outputs.sg_ssh,
    data.terraform_remote_state.vpc.outputs.sg_factory_server,
  ]
  subnets = data.terraform_remote_state.vpc.outputs.public_subnets
  user_data = file("./install.sh")

  tags = {
    Terraform   = "true"
    Environment = local.env
  }
}

module "go_client_ec2" {
  source = "../../../modules/ec2"
  name = "${local.name}-factory-worker-100"
  number_of_instances = 1
  //  ami = "ami-ebd02392"
  iam_instance_profile = "bats"
  key_name = "devops"
  ami = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  security_groups = [
    data.terraform_remote_state.vpc.outputs.sg_tcp_9900,
    data.terraform_remote_state.vpc.outputs.sg_ssh,
  ]
  subnets = data.terraform_remote_state.vpc.outputs.private_subnets
  user_data = file("./install.sh")

  tags = {
    Terraform   = "true"
    Environment = local.env
  }
}

