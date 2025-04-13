
# VPC
resource "aws_vpc" "vpc-labs" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "vpc-labs"
  }
}

# IGW
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc-labs.id
}

# Route Table
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

# Define Main Route Table
resource "aws_main_route_table_association" "main-rtb" {
  vpc_id         = aws_vpc.vpc-labs.id
  route_table_id = aws_route_table.rtb-labs.id
}


# Public Subnets
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