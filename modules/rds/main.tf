resource "aws_db_instance" "scalable_rds" {
  identifier             = "scalable-rds"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t4g.micro"
  port                   = var.db_port
  allocated_storage      = 20
  max_allocated_storage  = 100
  storage_type           = "gp2"
  db_subnet_group_name   = aws_db_subnet_group.scalable_rds_subnet_group.name
  vpc_security_group_ids = [var.rds_sg_id]
  username               = var.db_username
  password               = var.db_password
  db_name                = var.db_name // Initialize databse name
  skip_final_snapshot    = true
  publicly_accessible    = false
  multi_az               = false
}

resource "aws_db_subnet_group" "scalable_rds_subnet_group" {
  name        = "scalable-rds-subnet-group"
  description = "Subnet group for scalable RDS instance"
  subnet_ids  = var.private_rds_subnets_ids
  tags = {
    Name = "scalable-rds-subnet-group"
  }
}
