############################
## Security groups
############################

provider "aws" {}

resource "aws_security_group" "app" {
  name        = "${module.vpc.name}-app-sg"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "${module.vpc.name}-app-sg"
  }
}

resource "aws_security_group" "worker" {
  name        = "${module.vpc.name}-worker-sg"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 9093
    to_port     = 9093
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "${module.vpc.name}-worker-sg"
  }

}

resource "aws_security_group" "bastion" {
  name        = "${module.vpc.name}-bastion-sg"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 60000
    to_port     = 61000
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 1234
    to_port     = 1234
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "${module.vpc.name}-bastion-sg"
  }
}


resource "aws_security_group" "tcp_9900" {
  name        = "${module.vpc.name}-tcp-9000-9900-sg"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 9000
    to_port     = 9900
    protocol    = "tcp"
    security_groups = [aws_security_group.bastion.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "${module.vpc.name}-tcp-9900-worker-sg"
  }
}

resource "aws_security_group" "factory_worker" {
  name        = "${module.vpc.name}-factory-worker-sg"
  vpc_id      = module.vpc.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "${module.vpc.name}-factory-worker-sg"
  }
}


resource "aws_security_group" "factory_server" {
  name        = "${module.vpc.name}-factory-server-sg"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 7420
    to_port     = 7420
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 7419
    to_port     = 7419
    protocol    = "tcp"
    security_groups = [aws_security_group.factory_worker.id, aws_security_group.worker.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "${module.vpc.name}-factory-server-sg"
  }
}

resource "aws_security_group" "redis" {
  name        = "${module.vpc.name}-redis-sg"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    security_groups = [aws_security_group.app.id, aws_security_group.worker.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "${module.vpc.name}-redis-sg"
  }
}


resource "aws_security_group" "ssh_tunnel" {
  name        = "${module.vpc.name}-ssh-tunnel-sg"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "${module.vpc.name}-ssh-tunnel-sg"
  }
}


// To be commented in production
resource "aws_security_group" "all" {
  name        = "${module.vpc.name}-all-sg"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "${module.vpc.name}-ssh-tunnel-sg"
  }
}

resource "aws_security_group" "postgres" {
  name        = "${module.vpc.name}-postgres-sg"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    security_groups = [aws_security_group.app.id, aws_security_group.worker.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "${module.vpc.name}-postgres-sg"
  }
}
