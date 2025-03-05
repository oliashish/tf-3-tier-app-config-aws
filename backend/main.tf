terraform {
  backend "s3" {
    region = "eu-west-1"
    bucket = "tfstate-bucket"
    key    = "terraform/terraform.tfstate"

  }
}
