module "network" {
  source = "../../modules/network"

  project_name         = var.project_name
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  availability_zones   = var.availability_zones
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  enable_nat_gateway   = var.enable_nat_gateway
}

module "ecs" {
  source = "../../modules/ecs"

  project_name       = var.project_name
  environment        = var.environment
  aws_region         = var.aws_region
  vpc_id             = module.network.vpc_id
  public_subnet_ids  = module.network.public_subnet_ids
  private_subnet_ids = module.network.private_subnet_ids

  container_image = var.container_image
  container_port  = var.container_port
  task_cpu        = var.task_cpu
  task_memory     = var.task_memory
  desired_count   = var.desired_count
}

module "rds" {
  source = "../../modules/rds"

  project_name          = var.project_name
  environment           = var.environment
  vpc_id                = module.network.vpc_id
  private_subnet_ids    = module.network.private_subnet_ids
  ecs_security_group_id = module.ecs.ecs_security_group_id

  db_name                 = var.db_name
  db_username             = var.db_username
  db_password             = var.db_password
  instance_class          = var.db_instance_class
  allocated_storage       = var.db_allocated_storage
  backup_retention_period = var.db_backup_retention_period
  deletion_protection     = var.db_deletion_protection
}
