terraform {
  required_providers {
    aws = {
      source  = "registry.terraform.io/hashicorp/aws"
      version = "~> 4.29"
    }
  }

}

provider "aws" {
  region = "us-east-1"
  alias  = "virginia"
}

provider "aws" {
  region = "ap-southeast-1"
  alias  = "singapore"
}


module "vpc" {
  providers = {
    aws = aws.singapore
  }

  source = "terraform-aws-modules/vpc/aws"

  name = "demo"
  cidr = "10.0.0.0/16"

  azs             = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "aws_instance" "frontend" {
  count    = var.instance_count
  provider = aws.singapore

  ami                     = var.ami
  instance_type           = var.instance_type
  disable_api_termination = var.disable_api_termination
  vpc_security_group_ids  = [aws_security_group.frontend.id]
  tags                    = var.tags
  user_data               = file("${path.module}/scripts/install_devopsdemoapp.sh")
  subnet_id               = element(module.vpc.public_subnets, 0)


  lifecycle {
    prevent_destroy = false
  }

  timeouts {
    create = "7m"
    delete = "1h"
  }
}




resource "aws_security_group" "frontend" {
  provider = aws.singapore

  name        = "frontend"
  description = "Open ports for Frontend Web App"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "SSH from Anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP from Anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow ALL Outgoing"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" : "Frontend Web App"
  }
}
