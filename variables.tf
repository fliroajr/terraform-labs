variable "region" {
  default     = "sa-east-1"
  description = "AWS region"
}

variable "db_password" {
  description = "RDS root user password"
  sensitive   = true
}
