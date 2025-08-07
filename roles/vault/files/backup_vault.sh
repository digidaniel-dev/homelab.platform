#!/bin/bash

set -euo pipefail

# Configuration
export VAULT_ADDR="http://127.0.0.1:8200"
BACKUP_DIR="/mnt/nfs/vault_backups"
RETENTION_DAYS=30
TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)
BACKUP_FILE="${BACKUP_DIR}/vault_backup_${TIMESTAMP}.snap"
LATEST_SYMLINK="${BACKUP_DIR}/latest.snap"
LOG_FILE="/var/log/backup_vault.log"

# Control that VAULT_TOKEN exists
if [[ -z "${VAULT_TOKEN:-}" ]]; then
  echo "VAULT_TOKEN is not set. Export it before running the script." >> $LOG_FILE
  exit 1
fi

# Makes sure backup folder exists
mkdir -p "$BACKUP_DIR"

# Create backup
vault operator raft snapshot save "$BACKUP_FILE"

# Create symlink for latest backup
ln -sf "$(basename "$BACKUP_FILE")" "$LATEST_SYMLINK"

# Remove backups older than 30 days
find "$BACKUP_DIR" -name 'vault_backup_*.snap' -type f -mtime +$RETENTION_DAYS -exec rm {} \;

echo "Backup skapad: $BACKUP_FILE" >> $LOG_FILE
