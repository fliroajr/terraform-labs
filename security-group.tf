
# Security Group
resource "aws_security_group" "secg-labs" {
  name   = "secg-labs"
  vpc_id = aws_vpc.vpc-labs.id

  ingress {
    from_port   = 3306
    to_port     = 3306
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