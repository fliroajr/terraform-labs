# Configure the AWS Provider
provider "aws" {
  region = "sa-east-1"
}

# Create a VPC
resource "aws_vpc" "vpc-labs" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "vpc-labs"
  }
}

# Create IGW
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc-labs.id
}

# Create Subnets
resource "aws_subnet" "subnet-1" {
  vpc_id     = aws_vpc.vpc-labs.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "sa-east-1a"

  tags = {
    Name = "pub-subnet-labs-1"
  }
}

resource "aws_subnet" "subnet-2" {
  vpc_id     = aws_vpc.vpc-labs.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "sa-east-1b"

  tags = {
    Name = "pub-subnet-labs-2"
  }
}

resource "aws_subnet" "subnet-3" {
  vpc_id     = aws_vpc.vpc-labs.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "sa-east-1c"

  tags = {
    Name = "pub-subnet-labs-3"
  }
}

resource "aws_security_group" "secg-labs" {
  name   = "secg-labs"
  vpc_id = aws_vpc.vpc-labs.id

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

# Create DB subnet group
resource "aws_db_subnet_group" "sng-labs" {
  name       = "sng-labs"
  subnet_ids = [aws_subnet.subnet-1.id, aws_subnet.subnet-2.id, aws_subnet.subnet-3.id]

  tags = {
    Name = "sng-labs"
  }
}

# Create RDS option group
resource "aws_db_option_group" "og-mysql-labs" {
  name = "og-mysql-labs"
  option_group_description = "Option Group"
  engine_name              = "mysql"
  major_engine_version     = "8.0"
}

# Create RDS parameter group
resource "aws_db_parameter_group" "pg-mysql8-labs" {
  name   = "pg-mysql8-labs"
  family = "mysql8.0"
}


# Create RDS instance
resource "aws_db_instance" "rds-mysql-labs" {
  identifier             = "rds-mysql-labs"
  instance_class         = "db.t3.micro"
  allocated_storage      = 10
  engine                 = "mysql"
  engine_version         = "8.0"
  username               = "admin"
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.sng-labs.name
  vpc_security_group_ids = [aws_security_group.secg-labs.id]
  parameter_group_name   = aws_db_parameter_group.pg-mysql8-labs.name
  option_group_name      = aws_db_option_group.og-mysql-labs.name
  publicly_accessible    = true
  skip_final_snapshot    = true
}