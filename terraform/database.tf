resource "aws_security_group" "db_sg" {
  name        = "project-bedrock-db-sg"
  description = "Allow database traffic from EKS worker nodes"
  vpc_id      = module.vpc.vpc_id

  # MySQL
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [module.eks.node_security_group_id]
  }

  # PostgreSQL
  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [module.eks.node_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Project = "karatu-2025-capstone"
  }
}

resource "aws_db_subnet_group" "db_subnets" {
  name       = "bedrock-db-subnet-group"
  subnet_ids = module.vpc.private_subnets
}

resource "aws_db_instance" "mysql" {
  identifier             = "bedrock-mysql"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  db_name                = "retail_catalog"
  username               = "dbadmin"
  password               = "SecurePass2026Target!"
  db_subnet_group_name   = aws_db_subnet_group.db_subnets.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  skip_final_snapshot    = true
}

resource "aws_db_instance" "postgres" {
  identifier        = "bedrock-postgres"
  engine            = "postgres"
  engine_version    = "17"
  instance_class    = "db.t3.micro"
  allocated_storage = 20

  db_name  = "retail_orders"
  username = "dbadmin"
  password = "SecurePass2026Target!"

  db_subnet_group_name   = aws_db_subnet_group.db_subnets.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]

  skip_final_snapshot = true

  tags = {
    Project = "karatu-2025-capstone"
  }
}


resource "aws_dynamodb_table" "carts" {
  name         = "retail-carts"
  billing_mode = "PAY_PER_REQUEST"

  hash_key = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    Project = "karatu-2025-capstone"
  }
}