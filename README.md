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

- [ ] Phase 0 — Repository initialization
- [ ] Phase 1 — Local PostgreSQL database
## Local Database Setup

### Start PostgreSQL
docker compose up -d

docker compose exec -T postgres \
  psql -U "$(cat secrets/db_user.txt)" -d hotel_bookings \
  < db/migrations/001_create_tables.sql

docker compose exec postgres \
  psql -U "$(cat secrets/db_user.txt)" -d hotel_bookings \
  -c "\dt"

- [ ] Phase 2 — Seed data and query optimization
- [ ] Phase 3 — Backup and restore
- [ ] Phase 4 — Terraform network module
- [ ] Phase 5 — Terraform RDS module
- [ ] Phase 6 — Terraform ECS module
- [ ] Phase 7 — Dev and prod environments
- [ ] Phase 8 — Terraform validation and GitHub Actions
- [ ] Phase 9 — Final documentation and verification