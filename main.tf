provider "aws" {
  region = "eu-west-1"
  profile = "terraform-user"
}

resource "aws_s3_bucket" "tfstate-bucket" {
  bucket = "tfstate-bucket"
}

resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr_block_value
  instance_tenancy = "default"

  tags = {
    Name = "main_vpc"
  }
}

resource "aws_subnet" "main_subnet" {
  vpc_id                  = aws_vpc.main.id
  map_public_ip_on_launch = true
  cidr_block              = var.subnet_cidr_block_value

  tags = {
    Name = "main_subnet"
  }
}

