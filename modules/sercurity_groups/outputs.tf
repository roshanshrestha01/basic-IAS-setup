output "postgres" {
  description = "postgres security group id"
  value       = aws_security_group.postgres.id
}

output "app" {
  description = "app security group id"
  value       = aws_security_group.app.id
}

output "worker" {
  description = "worker security group id"
  value       = aws_security_group.worker.id
}

output "ssh" {
  description = "ssh group id"
  value       = aws_security_group.ssh_tunnel.id
}

output "all" {
  description = "ssh group id"
  value       = aws_security_group.all.id
}