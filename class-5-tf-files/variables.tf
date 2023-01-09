variable "aws_access_key" {
  type        = string
  description = "aws_access_key_value"
  sensitive   = true
}

variable "aws_secret_key" {
  type        = string
  description = "aws_secret_key_value"
  sensitive   = true
}

variable "aws_region" {
  type        = string
  description = "AWS Regions"
  default     = "us-east-1"
}

variable "aws_cidr_vpc" {
  type        = string
  description = "cidr for vpc"
  default     = "10.0.0.0/16"
}

variable "aws_cidr_subnet" {
  type        = string
  description = "cidr vor aws seubnet"
  default     = "10.0.0.0/24"
}

variable "aws_dns_hostname" {
  type        = bool
  description = "aws dns hostname enable/disable"
  default     = true
}

variable "aws_tenancy_vpc" {
  type        = string
  description = "Tenancy information for vpc"
  default     = "default"
}

variable "public_ip_subnet" {
  type        = bool
  description = "Public ip attachment"
  default     = true
}

variable "cidr_block_for_rtb-1" {
  type    = string
  default = "0.0.0.0/0"
}

variable "aws_ami_name" {
  type    = string
  default = "ami-0ff8a91507f77f867"
}

variable "instance_type_name" {
  type    = string
  default = "t2.micro"
}

variable "company" {
  type = string
  default = "tecognize"
}

variable "course" {
  type = string
  description = "course type"
}
