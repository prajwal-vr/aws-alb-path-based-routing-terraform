terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.region
}

resource "random_string" "bucket_suffix" {
  length  = 6
  special = false
  upper   = false
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }

  filter {
    name   = "map-public-ip-on-launch"
    values = ["true"]
  }
}

data "aws_subnet" "public_details" {
  for_each = toset(data.aws_subnets.public.ids)
  id       = each.value
}

locals {
  public_subnets_sorted = sort([
    for s in data.aws_subnet.public_details : s.id
    if s.map_public_ip_on_launch == true
  ])

  selected_subnet_ids = slice(local.public_subnets_sorted, 0, 2)  # First two public subnets (sorted by ID for consistency)
}

module "s3" {
  source = "./modules/s3"

  bucket_name = "arr-bucket-${random_string.bucket_suffix.result}"
  files_to_upload = [
    { key = "apache.svg", path = "./advanced-request-routing-code/apache.svg" },
    { key = "blue-index.html", path = "./advanced-request-routing-code/blue-index.html" },
    { key = "blue-root-index.html", path = "./advanced-request-routing-code/blue-root-index.html" },
    { key = "hw-blue-py.css", path = "./advanced-request-routing-code/hw-blue-py.css" },
    { key = "hw-blue.css", path = "./advanced-request-routing-code/hw-blue.css" },
    { key = "hw-red-py.css", path = "./advanced-request-routing-code/hw-red-py.css" },
    { key = "hw-red.css", path = "./advanced-request-routing-code/hw-red.css" },
    { key = "python.png", path = "./advanced-request-routing-code/python.png" },
    { key = "red-index.html", path = "./advanced-request-routing-code/red-index.html" },
    { key = "red-root-index.html", path = "./advanced-request-routing-code/red-root-index.html" }
  ]

  depends_on = [random_string.bucket_suffix]
}

module "iam" {
  source = "./modules/iam"

  bucket_arn = module.s3.bucket_arn
}

module "security_group" {
  source = "./modules/security_group"

  vpc_id = data.aws_vpc.default.id
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

module "ec2" {
  source = "./modules/ec2"

  ami_id                = data.aws_ami.amazon_linux.id
  instance_type         = "t2.micro"
  iam_instance_profile  = module.iam.instance_profile_name
  security_group_ids    = [module.security_group.sg_id]
  subnet_ids            = local.selected_subnet_ids
  user_data_red         = templatefile("./advanced-request-routing-code/user-data-red.md", { bucket_name = module.s3.bucket_name })
  user_data_blue        = templatefile("./advanced-request-routing-code/user-data-blue.md", { bucket_name = module.s3.bucket_name })
}

module "alb" {
  source = "./modules/alb"

  vpc_id             = data.aws_vpc.default.id
  subnet_ids         = local.selected_subnet_ids
  security_group_ids = [module.security_group.sg_id]
  red_instance_id    = module.ec2.red_instance_id
  blue_instance_id   = module.ec2.blue_instance_id
}