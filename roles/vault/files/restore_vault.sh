#!/bin/bash
set -e

LOG_FILE="/var/log/restore_vault.log"
TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)

if [ -f /mnt/nfs/vault_backups/latest.snap ]; then
  vault operator raft snapshot restore /mnt/nfs/vault_backups/latest.snap
  echo "[$TIMESTAMP] Backup restored" > $LOG_FILE
else
  echo "[$TIMESTAMP] No backup found" > $LOG_FILE
  exit 1
fi

