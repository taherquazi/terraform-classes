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
  region = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

#### Resource

### NETWORKING
## VPC
resource "aws_vpc" "vpc_main" {
  cidr_block       = var.aws_cidr_vpc
  instance_tenancy = var.aws_tenancy_vpc
  enable_dns_hostnames = var.aws_dns_hostname

  tags = local.common_tags

}

## SUBNET

resource "aws_subnet" "subnet_public" {
  vpc_id     = aws_vpc.vpc_main.id
  cidr_block = var.aws_cidr_subnet
  map_public_ip_on_launch = "true"

  tags = local.common_tags

}

## IGW

resource "aws_internet_gateway" "igw_main" {
  vpc_id = aws_vpc.vpc_main.id

  tags = local.common_tags

}

## ROUTE
# ROUTE TABLE

resource "aws_route_table" "rtb_main" {
  vpc_id = aws_vpc.vpc_main.id

  route {
    cidr_block = var.cidr_block_for_rtb-1
    gateway_id = aws_internet_gateway.igw_main.id
  }

  tags = local.common_tags

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

  tags = local.common_tags
}

#### INSTANCES

resource "aws_instance" "foo" {
  ami           = var.aws_ami_name
  instance_type = var.instance_type_name
  subnet_id = aws_subnet.subnet_public.id
  vpc_security_group_ids = [aws_security_group.sg_main.id]
  user_data = <<EOF
#! /bin/bash
sudo yum install nginx -y
sudo service nginx start 
EOF

  tags = local.common_tags

}
