data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "terraform-remote-state-management-bucket"
    key    = "staging/vpc/terraform.tfstate"
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

module "bastion" {
  source = "../../modules/ec2"
  name = "staging-bastion"
  number_of_instances = 1
  //  ami = "ami-ebd02392"
  ami = data.aws_ami.ubuntu.id
  iam_instance_profile = "bastion"
  key_name = "devops"
  instance_type = "t2.micro"
  security_groups = [
    data.terraform_remote_state.vpc.outputs.sg_app,
    data.terraform_remote_state.vpc.outputs.sg_ssh,
    data.terraform_remote_state.vpc.outputs.sg_all
  ]
  subnets = data.terraform_remote_state.vpc.outputs.public_subnets
  user_data = file("./install.sh")

  tags = {
    Terraform   = "true"
    Environment = "staging"
  }
}

// Uncomment to assign elastic ip to bastion

resource "aws_eip" "bastion_ec2" {
  vpc      = true
  instance = module.bastion.id[0]
}