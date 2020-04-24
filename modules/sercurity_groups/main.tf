provider "aws" {}

resource "aws_security_group" "app" {
  name        = "${var.name}-app"
  vpc_id      = var.vpc_id

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

  tags = merge(
    {
      "Name" = "${var.name}-app"
    },
    var.tags,
  )
}

resource "aws_security_group" "worker" {
  name        = "${var.name}-worker"
  vpc_id      = var.vpc_id

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

  tags = merge(
    {
      "Name" = "${var.name}-worker"
    },
    var.tags,
  )

}

resource "aws_security_group" "bastion" {
  name        = "${var.name}-bastion"
  vpc_id      = var.vpc_id

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

  tags = merge(
  {
    "Name" = "${var.name}-bastion"
  },
  var.tags,
  )
}


resource "aws_security_group" "tcp_9900" {
  name        = "${var.name}-tcp-9000-9900"
  vpc_id      = var.vpc_id

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

  tags = merge(
  {
    "Name" = "${var.name}-tcp-9900-worker"
  },
  var.tags,
  )
}

resource "aws_security_group" "factory_worker" {
  name        = "${var.name}-factory-worker"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
  {
    "Name" = "${var.name}-factory-worker"
  },
  var.tags,
  )
}


resource "aws_security_group" "factory_server" {
  name        = "${var.name}-factory-server"
  vpc_id      = var.vpc_id

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

  tags = merge(
  {
    "Name" = "${var.name}-factory-server"
  },
  var.tags,
  )
}

resource "aws_security_group" "redis" {
  name        = "${var.name}-redis"
  vpc_id      = var.vpc_id

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

  tags = merge(
  {
    "Name" = "${var.name}-redis"
  },
  var.tags,
  )

}


resource "aws_security_group" "ssh_tunnel" {
  name        = "${var.name}-ssh-tunnel"
  vpc_id      = var.vpc_id

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
  vpc_id      = var.vpc_id

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

  tags = merge(
  {
    "Name" = "${var.name}-ssh-tunnel"
  },
  var.tags,
  )

}

resource "aws_security_group" "postgres" {
  name        = "${var.name}-postgres"
  vpc_id      = var.vpc_id

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

  tags = merge(
  {
    "Name" = "${var.name}-postgres"
  },
  var.tags,
  )

}
