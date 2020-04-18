module "vpc" {
  source = "./modules/vpc/"
  environment = "production"
}