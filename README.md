# DevOps Terraform + Database Reliability Assessment

This project demonstrates:

- AWS infrastructure design using Terraform
- Environment-specific Terraform configuration
- Local PostgreSQL database using Docker Compose
- Database migrations and seed data
- Query optimization using indexes
- Database backup and restore
- Terraform validation using GitHub Actions

## Architecture

Internet → ALB → ECS/Fargate → RDS PostgreSQL

## Project Status

- [x] Phase 0 — Repository initialization
- [x] Phase 1 — Local PostgreSQL database
- [x] Phase 2 — Seed data and query optimization
- [x] Phase 3 — Backup and restore
- [x] Phase 4 — Terraform network module
- [x] Phase 5 — Terraform RDS module
- [x] Phase 6 — Terraform ECS module
- [x] Phase 7 — Dev and prod environments
- [x] Phase 8 — Terraform validation and GitHub Actions
- [x] Phase 9 — Final documentation and verification

## Terraform Infrastructure

Terraform is organized into reusable modules for the VPC/network, ECS/Fargate
application load balancer, and private PostgreSQL RDS database. The `dev` and
`prod` environments compose these modules with environment-specific sizing and
CIDR ranges.

Create a local variables file from the relevant example and replace the
placeholder database credentials. The real `terraform.tfvars` files are
ignored by Git.

```bash
cp infra/envs/dev/terraform.tfvars.example infra/envs/dev/terraform.tfvars
cp infra/envs/prod/terraform.tfvars.example infra/envs/prod/terraform.tfvars
```

Review and apply an environment:

```bash
cd infra/envs/dev
terraform init
terraform fmt -recursive
terraform validate
terraform plan
terraform apply
```

Use the same commands from `infra/envs/prod` for the production environment.
The RDS endpoint is exposed as the `rds_endpoint` output after deployment.

GitHub Actions runs `terraform fmt`, `terraform init`, `terraform validate`,
and a refresh-free plan for both environments. Configure the repository secrets
`TF_DB_USERNAME` and `TF_DB_PASSWORD` before enabling the workflow.

## Local Database Setup

### Start PostgreSQL

```bash
docker compose up -d
```

### Apply migrations and seed data

```bash
docker compose exec -T postgres \
  psql -U "$(cat secrets/db_user.txt)" -d hotel_bookings \
  < db/migrations/001_create_tables.sql

docker compose exec -T postgres \
  psql -U "$(cat secrets/db_user.txt)" -d hotel_bookings \
  < db/migrations/002_add_indexes.sql

docker compose exec -T postgres \
  psql -U "$(cat secrets/db_user.txt)" -d hotel_bookings \
  < db/seed/seed.sql
```

### Verify the database

```bash
docker compose exec postgres \
  psql -U "$(cat secrets/db_user.txt)" -d hotel_bookings \
  -c "SELECT COUNT(*) AS bookings FROM hotel_bookings;"

docker compose exec postgres \
  psql -U "$(cat secrets/db_user.txt)" -d hotel_bookings \
  -c "SELECT COUNT(*) AS events FROM booking_events;"
```

The seed creates 200 hotel bookings and 50 booking events. The
`idx_hotel_bookings_city_created_at` index supports filtering and sorting by
city and creation time.

## Backup and Restore

Create a timestamped SQL backup:

```bash
./scripts/backup.sh
```

Restore a backup file:

```bash
./scripts/restore.sh backups/hotel_bookings_YYYYMMDD_HHMMSS.sql
```
