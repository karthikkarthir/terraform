terraform {
  required_version = ">= 0.15"
  backend "s3" {
    bucket = "my-bucket-6"
    key = "my/state.tfstate"  
    region = "us-east-1"  
  }
}



provider "aws" {
 region = "us-east-1"
  
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = var.vpc_cidr

  azs             = [var.subnet-az]
  public_subnets  = [var.subnet_cidr]
  public_subnet_tags = {Name = "${var.env_tag}-subnet-1"}


  tags = { Name = "${var.env_tag}-vpc"}
}



module "webserver" {
  source = "./modules/webserver" 
  vpc_id = module.vpc.vpc_id
  subnet_id = module.vpc.public_subnets[0]
  ingress-ip = var.ingress-ip
  key_pair = var.key_pair
  inst_type = var.inst_type
  env_tag = var.env_tag
  imagename = var.imagename

}









