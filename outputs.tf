# mysql

output "mysql_rds_hostname" {
  description = "RDS instance hostname"
  value       = aws_db_instance.rds-mysql-labs.endpoint
  sensitive   = false
}

output "mysql_rds_port" {
  description = "RDS instance port"
  value       = aws_db_instance.rds-mysql-labs.port
  sensitive   = false
}

output "mysql_rds_username" {
  description = "RDS instance root username"
  value       = aws_db_instance.rds-mysql-labs.username
  sensitive   = true
}

# postgres

# output "psql_rds_hostname" {
#   description = "RDS instance hostname"
#   value       = aws_db_instance.rds-psql-labs.endpoint
#   sensitive   = false
# }

# output "psql_rds_port" {
#   description = "RDS instance port"
#   value       = aws_db_instance.rds-psql-labs.port
#   sensitive   = false
# }

# output "psql_rds_username" {
#   description = "RDS instance root username"
#   value       = aws_db_instance.rds-psql-labs.username
#   sensitive   = true
# }