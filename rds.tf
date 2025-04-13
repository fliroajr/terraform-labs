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
  major_engine_version     = "8.4"
}

# Create mysql RDS parameter group
resource "aws_db_parameter_group" "pg-mysql84-labs" {
  name   = "pg-mysql84-labs"
  family = "mysql8.4"
}


# Create mysql RDS instance
resource "aws_db_instance" "rds-mysql-labs" {
  identifier             = "rds-mysql-labs"
  instance_class         = "db.t4g.micro"
  allocated_storage      = 20
  engine                 = "mysql"
  engine_version         = "8.4.4"
  storage_type           = "gp2"
  apply_immediately      = true
  username               = var.db_username
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.sng-labs.name
  vpc_security_group_ids = [aws_security_group.secg-labs.id]
  parameter_group_name   = aws_db_parameter_group.pg-mysql84-labs.name
  option_group_name      = aws_db_option_group.og-mysql-labs.name
  # performance_insights_enabled    = true
  # performance_insights_kms_key_id = "arn:aws:kms:sa-east-1:323005945174:key/7bc7927b-e6d7-4c8c-b50e-956575886093"
  publicly_accessible = true
  skip_final_snapshot = true

  depends_on = [
    aws_db_subnet_group.sng-labs,
    aws_db_option_group.og-mysql-labs,
    aws_db_parameter_group.pg-mysql84-labs
  ]
}

##### PostgreSQL ######


# # Create postgres RDS option group
# resource "aws_db_option_group" "og-psql-labs" {
#   name                     = "og-psql-labs"
#   option_group_description = "Option Group"
#   engine_name              = "psql"
#   major_engine_version     = "16.0"
# }

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
