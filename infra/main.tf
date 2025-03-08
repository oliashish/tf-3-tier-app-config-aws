provider "aws" {
  region = "eu-west-1"
}


# Create VPC for the infra
resource "aws_vpc" "my_tf_vpc" {
  cidr_block           = var.vpc_cidr_block
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  tags = {
    name = "my_tf_vpc"
  }
}

# Create public subnet for accessing the server
resource "aws_subnet" "my_public_tf_subnet" {
  vpc_id                  = aws_vpc.my_tf_vpc.id
  cidr_block              = var.subnet_public_cidr_block
  availability_zone       = "eu-west-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "my_public_tf_subnet"
  }
}

# Create private subnet for accessing the server
resource "aws_subnet" "my_private_tf_subnet" {
  vpc_id                  = aws_vpc.my_tf_vpc.id
  cidr_block              = var.subnet_private_cidr_block
  availability_zone       = "eu-west-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "my_private_tf_subnet"
  }
}

# Internet Gateway to allow public internet access to VPC
resource "aws_internet_gateway" "my_tf_igw" {
  vpc_id = aws_vpc.my_tf_vpc.id

  tags = {
    Name = "my_tf_igw"
  }
}

# Route Table
resource "aws_route_table" "my_tf_RT" {
  vpc_id = aws_vpc.my_tf_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_tf_igw.id
  }

}

# TODO: Route Table Associations Public
resource "aws_route_table_association" "my_tf_RTA_1" {
  route_table_id = aws_route_table.my_tf_RT.id
  subnet_id      = aws_subnet.my_public_tf_subnet.id
}

# TODO: Route Table Associations Private
resource "aws_route_table_association" "my_tf_RTA_2" {
  route_table_id = aws_route_table.my_tf_RT.id
  subnet_id      = aws_subnet.my_private_tf_subnet.id
}

#  Security Groups
resource "aws_security_group" "my_tf_sg" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.my_tf_vpc.id

  tags = {
    Name = "my_tf_sg"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

# Application Load balancer
resource "aws_lb" "my-tf-elb" {
  name               = "my-tf-elb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [aws_security_group.my_tf_sg.id]
  subnets         = [aws_subnet.my_private_tf_subnet.id, aws_subnet.my_public_tf_subnet.id]


  tags = {
    Name = "my-tf-elb"
  }
}

resource "aws_lb_target_group" "my-tf-tg" {
  name     = "my-tf-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.my_tf_vpc.id

  health_check {
    path = "/"
    port = "traffic-port"
  }
}

resource "aws_lb_target_group_attachment" "my-tf-tg-attachment" {
  target_group_arn = aws_lb_target_group.my-tf-tg.arn
  target_id        = aws_instance.my_tf_instance.id
  port             = 80
}

resource "aws_lb_listener" "my-tf-listener" {
  load_balancer_arn = aws_lb.my-tf-elb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.my-tf-tg.arn
    type             = "forward"
  }
}

# RSA key of size 4096 bits
resource "tls_private_key" "my_rsa_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "my_tf_key" {
  key_name   = var.key_name
  public_key = tls_private_key.my_rsa_key.public_key_openssh
}

resource "local_file" "tf_key" {
  content  = tls_private_key.my_rsa_key.private_key_pem
  filename = var.file_name

}

# ec2 instance
resource "aws_instance" "my_tf_instance" {
  ami                         = var.ami_id # ubuntu instance
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = aws_subnet.my_public_tf_subnet.id
  vpc_security_group_ids      = [aws_security_group.my_tf_sg.id]
  associate_public_ip_address = true

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = tls_private_key.my_rsa_key.private_key_pem
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y nginx",
      "sudo service nginx start"
    ]
  }

  tags = {
    Name = "my_tf_instance"
  }
}

