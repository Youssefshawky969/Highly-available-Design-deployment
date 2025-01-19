resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group"
  subnet_ids = [aws_subnet.vpc_1_private_subnet_1.id, aws_subnet.vpc_1_private_subnet_2.id]
}

resource "aws_db_instance" "rds_instance" {
  allocated_storage      = 20
  engine                 = "mysql"
  engine_version         = "8.0.39"
  instance_class         = "db.m5.large"
  identifier             = "mydatabase"
  username               = "admin"
  password               = var.db_credentail
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  multi_az               = true
  publicly_accessible    = false
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  tags                   = { Name = "my-rds-instance" }
}
