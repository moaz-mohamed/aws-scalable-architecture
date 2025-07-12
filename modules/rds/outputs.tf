output "db_host" {
   value = aws_db_instance.scalable_rds.address
}

output "db_username" {
   value = aws_db_instance.scalable_rds.username
}

output "db_password" {
   value = aws_db_instance.scalable_rds.password
   sensitive = true
}

output "db_name" {
   value = aws_db_instance.scalable_rds.db_name
}

