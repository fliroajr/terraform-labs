# Configure the AWS Provider
provider "aws" {
  region = "sa-east-1"
}

# Create a VPC
resource "aws_vpc" "vpc-labs" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "vpc-labs"
  }
}