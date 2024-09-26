resource "aws_db_instance" "primary" {
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  identifier                = var.db_name
  username             = var.db_username
  password             = var.db_password
  parameter_group_name = "default.mysql8.0"
  publicly_accessible  = false
  vpc_security_group_ids = [var.security_group_id]
  db_subnet_group_name = var.subnet_group

  multi_az            = true
  availability_zone   = var.primary_az
  backup_retention_period = 7
  skip_final_snapshot = true

  tags = {
    Name = "${var.name}-primary-rds"
  }
}

resource "aws_db_instance" "replica" {
  count = var.create_replica ? 1 : 0
  identifier              = "${var.name}-read-replica"
  engine                  = aws_db_instance.primary.engine
  engine_version          = aws_db_instance.primary.engine_version
  instance_class          = aws_db_instance.primary.instance_class
  replicate_source_db     = aws_db_instance.primary.id 
  publicly_accessible     = false
  vpc_security_group_ids  = [var.security_group_id]
  db_subnet_group_name    = var.subnet_group
  availability_zone       = var.replica_az

  tags = {
    Name = "${var.name}-read-replica"
  }
}

resource "aws_db_subnet_group" "your_db_subnet_group_name" {
  name       = "${var.name}-db-subnet-group"
  subnet_ids = var.subnet_ids
  tags = {
    Name = "${var.name}-db-subnet-group"
  }
}
