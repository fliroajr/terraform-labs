# Configure the AWS Provider
provider "aws" {
  region = "sa-east-1"
}

# Create a VPC
resource "aws_vpc" "vpc-labs" {
  cidr_block           = "10.0.0.0/16"
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

# Create route table
resource "aws_route_table" "rtb-labs" {
  vpc_id = aws_vpc.vpc-labs.id

  route {
    cidr_block = aws_vpc.vpc-labs.cidr_block
    gateway_id = "local"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "rtb-labs"
  }
  depends_on = [
    aws_vpc.vpc-labs,
    aws_internet_gateway.igw
  ]
}

resource "aws_main_route_table_association" "main-rtb" {
  vpc_id         = aws_vpc.vpc-labs.id
  route_table_id = aws_route_table.rtb-labs.id
}


# Create Subnets
resource "aws_subnet" "subnet-pub-1" {
  vpc_id            = aws_vpc.vpc-labs.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "sa-east-1a"

  tags = {
    Name = "snet-pub-1"
  }
  depends_on = [
    aws_vpc.vpc-labs
  ]
}

resource "aws_subnet" "subnet-pub-2" {
  vpc_id            = aws_vpc.vpc-labs.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "sa-east-1b"

  tags = {
    Name = "snet-pub-2"
  }
  depends_on = [
    aws_vpc.vpc-labs
  ]
}

resource "aws_subnet" "subnet-pub-3" {
  vpc_id            = aws_vpc.vpc-labs.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "sa-east-1c"

  tags = {
    Name = "snet-pub-1"
  }
  depends_on = [
    aws_vpc.vpc-labs
  ]
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

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg-labs"
  }
  depends_on = [
    aws_vpc.vpc-labs
  ]
}

# Create DB subnet group
resource "aws_db_subnet_group" "sng-labs" {
  name       = "sng-labs"
  subnet_ids = [aws_subnet.subnet-pub-1.id, aws_subnet.subnet-pub-2.id, aws_subnet.subnet-pub-3.id]

  tags = {
    Name = "sng-labs"
  }
  depends_on = [
    aws_vpc.vpc-labs
  ]
}

# Create mysql RDS option group
resource "aws_db_option_group" "og-mysql-labs" {
  name                     = "og-mysql-labs"
  option_group_description = "Option Group"
  engine_name              = "mysql"
  major_engine_version     = "8.0"
}

# Create mysql RDS parameter group
resource "aws_db_parameter_group" "pg-mysql8-labs" {
  name   = "pg-mysql8-labs"
  family = "mysql8.0"
}


# Create mysql RDS instance
resource "aws_db_instance" "rds-mysql-labs" {
  identifier             = "rds-mysql-labs"
  instance_class         = "db.t4g.micro"
  allocated_storage      = 20
  engine                 = "mysql"
  engine_version         = "8.0.39"
  storage_type           = "gp3"
  apply_immediately      = true
  username               = var.db_username
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.sng-labs.name
  vpc_security_group_ids = [aws_security_group.secg-labs.id]
  parameter_group_name   = aws_db_parameter_group.pg-mysql8-labs.name
  option_group_name      = aws_db_option_group.og-mysql-labs.name
  # performance_insights_enabled    = true
  # performance_insights_kms_key_id = "arn:aws:kms:sa-east-1:323005945174:key/7bc7927b-e6d7-4c8c-b50e-956575886093"
  publicly_accessible = true
  skip_final_snapshot = true

  depends_on = [
    aws_db_subnet_group.sng-labs,
    aws_db_option_group.og-mysql-labs,
    aws_db_parameter_group.pg-mysql8-labs
  ]
}

# # Create postgres RDS parameter group
# resource "aws_db_parameter_group" "pg-psql16-labs" {
#   name   = "pg-psql16-labs"
#   family = "postgres16"
# }


# # Create postgres RDS instance
# resource "aws_db_instance" "rds-psql-labs" {
#   identifier             = "rds-psql-labs"
#   instance_class         = "db.t4g.micro"
#   allocated_storage      = 20
#   engine                 = "postgres"
#   engine_version         = "16.4"
#   apply_immediately      = true
#   storage_type           = "gp3"
#   username               = var.db_username
#   password               = var.db_password
#   db_subnet_group_name   = aws_db_subnet_group.sng-labs.name
#   vpc_security_group_ids = [aws_security_group.secg-labs.id]
#   parameter_group_name   = aws_db_parameter_group.pg-psql16-labs.name
#   # performance_insights_enabled    = true
#   # performance_insights_kms_key_id = "arn:aws:kms:sa-east-1:323005945174:key/7bc7927b-e6d7-4c8c-b50e-956575886093"
#   publicly_accessible = true
#   skip_final_snapshot = true

#   depends_on = [
#     aws_db_subnet_group.sng-labs,
#     aws_db_parameter_group.pg-psql16-labs
#   ]
# }
