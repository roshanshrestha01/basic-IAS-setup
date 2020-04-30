output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "sg_postgres" {
  value = aws_security_group.postgres.id
}

output "sg_app" {
  value = aws_security_group.app.id
}

output "sg_worker" {
  value = aws_security_group.worker.id
}

output "sg_ssh" {
  value = aws_security_group.ssh_tunnel.id
}

output "sg_factory_server" {
  value = aws_security_group.factory_server.id
}

output "sg_all" {
  value = aws_security_group.all.id
}

output "sg_tcp_9900" {
  value = aws_security_group.tcp_9900.id
}