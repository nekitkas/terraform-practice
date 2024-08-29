terraform {
  required_version = ">= 0.12"
  backend "s3" {
    bucket = "demo-terraformbucket"
    key = "myapp/state.tfstate"
    region = "eu-west-1"
  }
}

provider "aws" {
  region = "eu-west-1"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.env_prefix}-vpc"
  cidr = var.vpc_cidr-block

  azs             = [var.avail_zone]
  public_subnets  = [var.subnet_cidr_block]
  public_subnet_tags = {
    Name = "${var.env_prefix}-public"
  }

  tags = {
    Name = "${var.env_prefix}-vpc"
  }
}

module "web_server" {
  source = "./modules/webserver"
  vpc_id = module.vpc.vpc_id
  subnet_id = module.vpc.public_subnets[0]
  private_key_location = var.private_key_location
  public_key_location = var.public_key_location
  instance_type = var.instance_type
  env_prefix = var.env_prefix
  my_ip = var.my_ip
  avail_zone = var.avail_zone
}


