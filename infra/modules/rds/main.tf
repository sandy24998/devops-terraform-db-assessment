locals {
  name = "${var.project_name}-${var.environment}"
}

resource "aws_db_subnet_group" "this" {
  name       = "${local.name}-db-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name        = "${local.name}-db-subnet-group"
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_security_group" "rds" {
  name        = "${local.name}-rds-sg"
  description = "Allow PostgreSQL access from ECS tasks"
  vpc_id      = var.vpc_id

  ingress {
    description     = "PostgreSQL from ECS"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [var.ecs_security_group_id]
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${local.name}-rds-sg"
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_db_instance" "this" {
  identifier = "${local.name}-postgres"

  engine         = "postgres"
  engine_version = "16"

  instance_class        = var.instance_class
  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.allocated_storage * 2
  storage_type          = "gp3"
  storage_encrypted     = true

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password
  port     = 5432

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  publicly_accessible    = false

  backup_retention_period = var.backup_retention_period
  backup_window           = "03:00-04:00"
  maintenance_window      = "sun:04:00-sun:05:00"

  multi_az            = false
  deletion_protection = var.deletion_protection
  skip_final_snapshot = true

  auto_minor_version_upgrade = true
  copy_tags_to_snapshot      = true

  tags = {
    Name        = "${local.name}-postgres"
    Project     = var.project_name
    Environment = var.environment
  }
}
