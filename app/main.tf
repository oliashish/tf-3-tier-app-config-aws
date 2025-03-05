provider "aws" {
  region = "eu-west-1"
}

resource "aws_vpc" "main" {}

resource "aws_subnet" "main_subnet" {
  vpc_id = ""
}

