variable "vpc_cidr_block" {
  description = "CIDR range value for VPC"
}
variable "subnet_public_cidr_block" {
  description = "CIDR range value for public subnet"
}
variable "subnet_private_cidr_block" {
  description = "CIDR range value for private subnet"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
}

variable "instance_type" {
  description = "Instance type for the EC2 instance"
}

variable "key_name" {
  description = "Key name for the EC2 instance"
}

variable "file_name" {
  description = "File name for the RSA key"
}
