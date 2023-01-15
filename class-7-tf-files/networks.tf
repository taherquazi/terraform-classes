terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

### Provider

provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}


### Data

data "aws_availability_zones" "available" {
  state = "available"
}

### Resource


resource "aws_vpc" "vpc-1" {
  cidr_block           = var.aws_cidr_vpc
  instance_tenancy     = var.aws_tenancy_vpc
  enable_dns_hostnames = var.aws_dns_hostname

  tags = local.common_tags
}

resource "aws_subnet" "sub-1" {
  vpc_id                  = aws_vpc.vpc-1.id
  cidr_block              = var.aws_cidr_subnet[0]
  map_public_ip_on_launch = var.public_ip_subnet
  availability_zone       = data.aws_availability_zones.available.names[0]

  tags = local.common_tags
}

resource "aws_subnet" "sub-2" {
  vpc_id                  = aws_vpc.vpc-1.id
  cidr_block              = var.aws_cidr_subnet[1]
  map_public_ip_on_launch = var.public_ip_subnet
  availability_zone       = data.aws_availability_zones.available.names[1]

  tags = local.common_tags
}

resource "aws_internet_gateway" "igw-1" {
  vpc_id = aws_vpc.vpc-1.id
  tags   = local.common_tags
}

resource "aws_route_table" "rtb-1" {
  vpc_id = aws_vpc.vpc-1.id

  route {
    cidr_block = var.cidr_block_for_rtb-1
    gateway_id = aws_internet_gateway.igw-1.id
  }

  tags = local.common_tags
}

resource "aws_route_table_association" "rtb-as-1" {
  subnet_id      = aws_subnet.sub-1.id
  route_table_id = aws_route_table.rtb-1.id
}

resource "aws_route_table_association" "rtb-as-2" {
  subnet_id      = aws_subnet.sub-2.id
  route_table_id = aws_route_table.rtb-1.id
}


resource "aws_security_group" "sg-1" {
  vpc_id = aws_vpc.vpc-1.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.common_tags

}

resource "aws_security_group" "sg-2" {
  vpc_id = aws_vpc.vpc-1.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.common_tags

}

