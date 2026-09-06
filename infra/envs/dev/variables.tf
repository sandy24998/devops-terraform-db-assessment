variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
}

variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDRs"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "Private subnet CIDRs"
  type        = list(string)
}

variable "enable_nat_gateway" {
  description = "Enable NAT Gateway"
  type        = bool
  default     = true
}

variable "container_image" {
  description = "Container image for the ECS application"
  type        = string
}

variable "container_port" {
  description = "Application container port"
  type        = number
}

variable "task_cpu" {
  description = "Fargate task CPU units"
  type        = number
}

variable "task_memory" {
  description = "Fargate task memory in MB"
  type        = number
}

variable "desired_count" {
  description = "Number of ECS tasks"
  type        = number
}

variable "db_name" {
  type = string
}

variable "db_username" {
  type      = string
  sensitive = true
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "db_instance_class" {
  type = string
}

variable "db_allocated_storage" {
  type = number
}

variable "db_backup_retention_period" {
  type = number
}

variable "db_deletion_protection" {
  type = bool
}
