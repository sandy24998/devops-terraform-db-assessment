#!/usr/bin/env bash

set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <backup-file>"
  exit 1
fi

BACKUP_FILE="$1"
DB_USER="$(cat secrets/db_user.txt)"
DB_NAME="hotel_bookings"

if [[ ! -f "${BACKUP_FILE}" ]]; then
  echo "Backup file not found: ${BACKUP_FILE}"
  exit 1
fi

docker compose exec -T postgres \
  psql \
  -U "${DB_USER}" \
  -d "${DB_NAME}" \
  < "${BACKUP_FILE}"

echo "Restore completed from: ${BACKUP_FILE}"