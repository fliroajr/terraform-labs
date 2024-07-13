provider "aws" {
  region = var.region
}

data "aws_availability_zones" "available" {}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.77.0"

  name                 = "vpc-labs"
  cidr                 = "10.0.0.0/16"
  azs                  = data.aws_availability_zones.available.names
  public_subnets       = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_db_subnet_group" "sng-labs" {
  name       = "sng-labs"
  subnet_ids = module.vpc.public_subnets

  tags = {
    Name = "sng-labs"
  }
}

resource "aws_security_group" "sg-labs" {
  name   = "sg-labs"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg-labs"
  }
}

resource "aws_db_parameter_group" "pg-labs" {
  name   = "pg-labs"
  family = "mysql8.0"
  description = "Parameter group for RDS labs instance"
}

resource "aws_db_instance" "rds-mysql-labs" {
  identifier             = "rds-mysql-labs"
  instance_class         = "db.t3.micro"
  allocated_storage      = 5
  engine                 = "mysql"
  engine_version         = "8.0"
  username               = "admin"
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.sg-labs.name
  vpc_security_group_ids = [aws_security_group.sg-labs.name]
  parameter_group_name   = aws_db_parameter_group.pg-labs.name
  publicly_accessible    = true
  skip_final_snapshot    = true
}
