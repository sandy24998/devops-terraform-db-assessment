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
- [ ] Phase 4 — Terraform network module
- [ ] Phase 5 — Terraform RDS module
- [ ] Phase 6 — Terraform ECS module
- [ ] Phase 7 — Dev and prod environments
- [ ] Phase 8 — Terraform validation and GitHub Actions
- [ ] Phase 9 — Final documentation and verification

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
