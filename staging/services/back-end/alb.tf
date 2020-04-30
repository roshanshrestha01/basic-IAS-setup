############################
## Elastic Loadbalancer
############################
module "alb"  {
  source = "../../../modules/alb"
  name = "staging-alb"
  subnets = data.terraform_remote_state.vpc.outputs.public_subnets
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
  ssl_certificate = "arn:aws:acm:us-west-2:724528953930:certificate/063718e2-5c04-401b-80d3-52a71bac1626"
  ec2_instances = concat(module.ec2.id, [])
  security_groups = [
    data.terraform_remote_state.vpc.outputs.sg_app,
  ]

  tags = {
    Terraform = "true"
  }
}
