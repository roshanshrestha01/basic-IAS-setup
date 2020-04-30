############################
## Elastic Loadbalancer
############################
module "alb"  {
  source = "..\/..\/modules\/alb"
  name = var.name
  subnets = module.vpc.public_subnets
  vpc_id = module.vpc.vpc_id
  ssl_certificate = "arn:aws:acm:us-west-2:724528953930:certificate/063718e2-5c04-401b-80d3-52a71bac1626"
  ec2_instances = concat(module.ec2.id, [])
  security_groups = [
    module.security_groups.app,
  ]

  tags = {
    Terraform = "true"
  }
}
