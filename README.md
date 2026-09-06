# DevOps Terraform and Database Assessment

This project contains Terraform infrastructure for AWS and a local PostgreSQL
database for hotel bookings.

## Architecture

Internet → ALB → ECS/Fargate → RDS PostgreSQL

## Terraform Infrastructure

The Terraform code has modules for the network, ECS/Fargate, and RDS. Both
`dev` and `prod` environments use these modules.

Create a local variables file from the relevant example and replace the
placeholder database credentials. The real `terraform.tfvars` files are
ignored by Git.

```bash
cp infra/envs/dev/terraform.tfvars.example infra/envs/dev/terraform.tfvars
cp infra/envs/prod/terraform.tfvars.example infra/envs/prod/terraform.tfvars
```

Check the dev environment:

```bash
cd infra/envs/dev
terraform init
terraform fmt -recursive
terraform validate
terraform plan -refresh=false -var-file=terraform.tfvars.example
cd ../../..
```

Check the prod environment:

```bash
cd infra/envs/prod
terraform init
terraform fmt -recursive
terraform validate
terraform plan -refresh=false -var-file=terraform.tfvars.example
cd ../../..
```

To deploy an environment, configure AWS credentials and run:

```bash
cd infra/envs/dev
terraform plan
terraform apply
```

Use the same commands from `infra/envs/prod` for the production environment.
The RDS endpoint is exposed as the `rds_endpoint` output after deployment.

The pull request workflow runs the same Terraform checks for both environments.
It also uploads the plans as `terraform-plan-dev` and `terraform-plan-prod`
artifacts. AWS credentials are only needed to run `terraform apply`.

## Local Database Setup

### Start PostgreSQL

```bash
docker compose up -d
docker compose ps
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

docker compose exec postgres \
  psql -U "$(cat secrets/db_user.txt)" -d hotel_bookings \
  -c "SELECT indexname FROM pg_indexes WHERE indexname = 'idx_hotel_bookings_city_created_at';"
```

The verification should report 200 bookings, 50 events, and the
`idx_hotel_bookings_city_created_at` index. This index supports filtering and
sorting by city and creation time.

## Backup and Restore

Create a timestamped SQL backup:

```bash
./scripts/backup.sh
```

Restore a backup file:

```bash
./scripts/restore.sh backups/hotel_bookings_YYYYMMDD_HHMMSS.sql
```

Verify the restore by rerunning the booking and event count queries above.
