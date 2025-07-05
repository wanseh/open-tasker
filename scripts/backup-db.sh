#!/bin/bash

# OpenTasker Database Backup Script

set -e

# Configuration
BACKUP_DIR="./backups"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="opentasker_backup_${TIMESTAMP}.sql"

# Database configuration (can be overridden by environment variables)
DB_HOST=${DATABASE_HOST:-localhost}
DB_PORT=${DATABASE_PORT:-5432}
DB_NAME=${DATABASE_NAME:-opentasker}
DB_USER=${DATABASE_USERNAME:-postgres}
DB_PASSWORD=${DATABASE_PASSWORD:-postgres}

echo "🗄️  Creating database backup..."

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Create backup
PGPASSWORD="$DB_PASSWORD" pg_dump \
    -h "$DB_HOST" \
    -p "$DB_PORT" \
    -U "$DB_USER" \
    -d "$DB_NAME" \
    --clean \
    --if-exists \
    --no-owner \
    --no-privileges \
    > "$BACKUP_DIR/$BACKUP_FILE"

# Compress backup
gzip "$BACKUP_DIR/$BACKUP_FILE"

echo "✅ Backup created: $BACKUP_DIR/${BACKUP_FILE}.gz"

# Keep only last 10 backups
echo "🧹 Cleaning old backups..."
cd "$BACKUP_DIR"
ls -t *.sql.gz | tail -n +11 | xargs -r rm

echo "✅ Backup process completed!" 