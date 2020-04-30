############################
## Elastic Loadbalancer
############################
module "alb"  {
  source = "../../../modules/alb"
  name = "staging-alb"
  subnets = data.terraform_remote_state.vpc.outputs.public_subnets
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
  ssl_certificate = "<arn>"
  ec2_instances = concat(module.ec2.id, [])
  security_groups = [
    data.terraform_remote_state.vpc.outputs.sg_app,
  ]

  tags = {
    Terraform = "true"
  }
}
