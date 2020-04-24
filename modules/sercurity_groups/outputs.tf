output "postgres" {
  value = aws_security_group.postgres.id
}

output "app" {
  value = aws_security_group.app.id
}

output "worker" {
  value = aws_security_group.worker.id
}

output "ssh" {
  value = aws_security_group.ssh_tunnel.id
}

output "factory_server" {
  value = aws_security_group.factory_server.id
}

output "all" {
  value = aws_security_group.all.id
}

output "tcp_9900" {
  value = aws_security_group.tcp_9900.id
}