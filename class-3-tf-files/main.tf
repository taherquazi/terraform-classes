#### Providers
#AWS Provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
  access_key = "AKIARHUDFI6XG2QEQIJQ"
  secret_key = "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"
}

#### Resource

### NETWORKING
## VPC
resource "aws_vpc" "vpc_main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_hostnames = "true"

}

## SUBNET

resource "aws_subnet" "subnet_public" {
  vpc_id     = aws_vpc.vpc_main.id
  cidr_block = "10.0.0.0/24"
  map_public_ip_on_launch = "true"

}

## IGW

resource "aws_internet_gateway" "igw_main" {
  vpc_id = aws_vpc.vpc_main.id

}

## ROUTE
# ROUTE TABLE

resource "aws_route_table" "rtb_main" {
  vpc_id = aws_vpc.vpc_main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_main.id
  }

}

## ROUTE TABLE ASSOCIATION

resource "aws_route_table_association" "rta_main" {
  subnet_id      = aws_subnet.subnet_public.id
  route_table_id = aws_route_table.rtb_main.id
}

#### SECURITY GROUPS

resource "aws_security_group" "sg_main" {
  vpc_id      = aws_vpc.vpc_main.id

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
 
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  
  }
}

#### INSTANCES

resource "aws_instance" "foo" {
  ami           = "ami-0ff8a91507f77f867"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.subnet_public.id
  vpc_security_group_ids = [aws_security_group.sg_main.id]
  user_data = <<EOF
#! /bin/bash
sudo yum install nginx -y
sudo service nginx start 
EOF

}
