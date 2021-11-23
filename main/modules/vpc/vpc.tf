provider "aws" {
  region = var.vpc_region
}

resource "aws_vpc" "vpc" {
  cidr_block       = var.cidr_block
  instance_tenancy = "default"

  tags = {
    Name = "${var.vpc_name}"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.vpc_name}"
  }
}

resource "aws_subnet" "sub" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.subnet_cidr

  tags = {
    Name = "subnet"
  }
}

resource "aws_default_route_table" "route_table" {
  default_route_table_id = aws_vpc.vpc.default_route_table_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  route {
    cidr_block                = var.peer_cidr_block
    vpc_peering_connection_id = var.peering_id
  }
  tags = {
    Name = "${var.vpc_name} route table"
  }
}

resource "aws_instance" "my_ubuntu" {
  ami           = var.ami
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.sub.id
  tags = {
    "Name" = "Amazon"
  }
  associate_public_ip_address = "true"
  vpc_security_group_ids      = [aws_security_group.my_webserver.id]
  user_data                   = <<EOF
                          #!/bin/bash
                          yum -y update
                          sudo amazon-linux-extras install nginx1
                          echo "<h2>My WebServer<h2>" > /var/www/html/index.html
                          sudo systemctl start nginx
                          EOF
}

resource "aws_security_group" "my_webserver" {
  name        = "my_webserver"
  description = "my sg"
  vpc_id      = aws_vpc.vpc.id

  dynamic "ingress" {
    for_each = ["80", "443", "22"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "region" {
  value = var.vpc_region
}

output "vpc_id" {
  value = aws_vpc.vpc.id
}


output "cidr_block" {
  value = var.cidr_block
}
