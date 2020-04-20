provider "aws" {}

resource "aws_security_group" "app" {
  name        = "${var.name}-app"
  description = "Allow TLS inbound traffic"
//  description = "Allow access to web app"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP opened for all"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS opened for all"
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

  tags = merge(
    {
      "Name" = "${var.name}-app"
    },
    var.tags,
  )
}

resource "aws_security_group" "worker" {
  name        = "${var.name}-worker"
  description = "Allow TLS inbound traffic"
//  description = "Allow access to worker"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP opened for all"
    from_port   = 9093
    to_port     = 9093
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP opened for all"
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
  tags = merge(
    {
      "Name" = "${var.name}-worker"
    },
    var.tags,
  )

}

resource "aws_security_group" "redis" {
  name        = "${var.name}-redis"
  description = "Allow redis inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "Open port for redis"
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

  tags = merge(
  {
    "Name" = "${var.name}-redis"
  },
  var.tags,
  )

}


resource "aws_security_group" "ssh_tunnel" {
  name        = "${var.name}-ssh-tunnel"
  description = "Allow ssh inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "Open port for ssh"
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

  tags = merge(
  {
    "Name" = "${var.name}-ssh-tunnel"
  },
  var.tags,
  )

}


// To be commented in production
resource "aws_security_group" "all" {
  name        = "${var.name}-all"
  description = "Allow all inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "Open port for all"
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

  tags = merge(
  {
    "Name" = "${var.name}-ssh-tunnel"
  },
  var.tags,
  )

}


resource "aws_security_group" "postgres" {
  name        = "${var.name}-postgres"
  description = "Allow postgres inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "Open port for postgres"
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

  tags = merge(
  {
    "Name" = "${var.name}-postgres"
  },
  var.tags,
  )

}
