resource "aws_secretsmanager_secret" "rds_db_secret" {
  name        = "rds/flask-app/credentials"
  description = "RDS database credentials secret"
  recovery_window_in_days = 0 # Disable recovery to allow immediate deletion
}

resource "aws_secretsmanager_secret_version" "rds_db_secret_version" {
  secret_id     = aws_secretsmanager_secret.rds_db_secret.id
  secret_string = jsonencode({
    host     = var.db_host
    username = var.db_username
    password = var.db_password
    dbname  = var.db_name
  })
}

