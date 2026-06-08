resource "aws_security_group" "rds" {
  name   = "bedrock-rds-sg"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [module.eks.node_security_group_id]
  }

  tags = local.tags
}

resource "aws_db_instance" "mysql" {
  identifier = "bedrock-mysql"

  engine         = "mysql"
  instance_class = "db.t3.micro"

  allocated_storage = 20

  db_name  = "retail"
  username = "admin"
  password = "StrongPassword123!"

  vpc_security_group_ids = [aws_security_group.rds.id]
  db_subnet_group_name    = module.vpc.database_subnet_group

  skip_final_snapshot = true
}
