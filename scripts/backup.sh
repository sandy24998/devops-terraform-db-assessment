#!/usr/bin/env bash

set -euo pipefail

DB_USER="$(cat secrets/db_user.txt)"
DB_NAME="hotel_bookings"
BACKUP_DIR="backups"
TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
BACKUP_FILE="${BACKUP_DIR}/hotel_bookings_${TIMESTAMP}.sql"

mkdir -p "${BACKUP_DIR}"

docker compose exec -T postgres \
  pg_dump \
  -U "${DB_USER}" \
  -d "${DB_NAME}" \
  --clean \
  --if-exists \
  > "${BACKUP_FILE}"

echo "Backup created: ${BACKUP_FILE}"