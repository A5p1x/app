terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "us-east-1"
}

data "aws_vpc" "default" {
  default = true
}

data "aws_caller_identity" "current" {}

data "aws_ecr_repository" "example" {
}

resource "aws_iam_role" "ec2_role" {
  name = "ec2_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "ecr_policy" {
  name = "ecr_policy"
  role = aws_iam_role.ec2_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ecr:*"
        ]
        Effect = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2_instance_profile"
  role = aws_iam_role.ec2_role.name
}

resource "aws_security_group" "allow_ssh_http" {
  name        = "allow_ssh_http"
  description = "Security group for SSH and HTTP access"
  vpc_id = data.aws_vpc.default.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
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

  tags = {
    Name = "allow_ssh_http"
  }
}

resource "aws_instance" "petproject-app-instance" {
  ami           = "ami-0bb84b8ffd87024d8"
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name
  instance_type = "t2.micro"
  associate_public_ip_address = true
  key_name = "stefanawsec2"
  vpc_security_group_ids = [aws_security_group.allow_ssh_http.id]
  user_data = <<-EOF
            #!/bin/bash
            sudo yum update -y
            sudo yum install docker -y
            sudo service docker start
            sudo usermod -a -G docker ec2-user
            aws ecr get-login-password --region ${var.region} | sudo docker login --username AWS --password-stdin ${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.region}.amazonaws.com
            sudo docker pull ${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.region}.amazonaws.com/${data.aws_ecr_repository.example.name}:latest
            sudo docker run -d -p 80:4949 ${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.region}.amazonaws.com/${data.aws_ecr_repository.example.name}:latest
            EOF
  tags = {
    Name = "petproject-instance"
  }
}
