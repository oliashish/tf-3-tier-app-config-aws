# Create bucket to support 3-tier application with backend storage
provider "aws" {
  region  = "eu-west-1"
  profile = "terraform-user"
}

resource "aws_s3_bucket" "tfstate-bucket" {
  bucket = "tfstate-bucket"
}
