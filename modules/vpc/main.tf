provider "aws" {}

# Setting up Initial VPC
resource "aws_vpc" "accounting_box_vpc" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = true

  tags = {
    Name = "accounting-box-${var.environment}-vpc"
  }
}

# Internet gateway
resource "aws_internet_gateway" "accounting_box_gateway" {
  vpc_id = "${aws_vpc.accounting_box_vpc.id}"

  tags = {
    Name = "${var.environment}-igw"
  }
}

# Security groups
resource "aws_security_group" "nat" {
  name        = "vpc_nat"
  description = "Allow traffic to pass from the private subnet to the internet"

  vpc_id = "${aws_vpc.accounting_box_vpc.id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${var.private_subnet_cidr}"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["${var.private_subnet_cidr}"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }
  egress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "NATSG"
  }
}


resource "aws_security_group" "allow_redis" {
  name        = "allow_redis"
  description = "Allow redis server"
  vpc_id      = "${aws_vpc.accounting_box_vpc.id}"

  ingress {
    description = "TLS from VPC"
    from_port   = 6397
    to_port     = 6397
    protocol    = "tcp"
    cidr_blocks = ["${aws_vpc.accounting_box_vpc.cidr_block}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-redis"
  }
}

resource "aws_eip" "nat" {
  vpc              = true
  public_ipv4_pool = "ipv4pool-ec2-012345"
}

# Public Subnet
resource "aws_subnet" "us_west_2_public" {
    vpc_id = "${aws_vpc.accounting_box_vpc.id}"

    cidr_block = "${var.public_subnet_cidr}"
    availability_zone = "us-west-2"

    tags = {
        Name = "public-subnet-${var.environment}"
    }
}

resource "aws_route_table" "us_west_2_public" {
    vpc_id = "${aws_vpc.accounting_box_vpc.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.accounting_box_gateway.id}"
    }

    tags = {
        Name = "public-subnet-${var.environment}"
    }
}

resource "aws_route_table_association" "us-west-2-public" {
    subnet_id = "${aws_subnet.us_west_2_public.id}"
    route_table_id = "${aws_route_table.us_west_2_public.id}"
}

# Private subnet
resource "aws_subnet" "us_west_2_private" {
    vpc_id = "${aws_vpc.accounting_box_vpc.id}"

    cidr_block = "${var.private_subnet_cidr}"
    availability_zone = "us-west-2"

    tags = {
        Name = "private-subnet-${var.environment}"
    }
}

resource "aws_nat_gateway" "public_ngw" {
  allocation_id = "${aws_eip.nat.id}"
  subnet_id     = "${aws_subnet.us_west_2_public.id}"

  tags = {
    Name = "gw NAT"
  }
}

resource "aws_route_table" "us_west_2_private" {
    vpc_id = "${aws_vpc.accounting_box_vpc.id}"

    route {
        cidr_block = "0.0.0.0/0"
        instance_id = "${aws_nat_gateway.public_ngw.id}"
    }

    tags = {
        Name = "private-subnet"
    }
}

resource "aws_route_table_association" "us_west_2_private" {
    subnet_id = "${aws_subnet.us_west_2_private.id}"
    route_table_id = "${aws_route_table.us_west_2_private.id}"
}





