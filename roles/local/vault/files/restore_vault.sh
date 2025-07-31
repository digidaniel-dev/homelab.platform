#!/bin/bash
set -e

LOG_FILE="/var/log/restore_vault.log"
TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)

export VAULT_ADDR=http://127.0.0.1:8200

if [ -f /mnt/nfs/vault_backups/latest.snap ]; then
  vault operator raft snapshot restore /mnt/nfs/vault_backups/latest.snap
  echo "[$TIMESTAMP] Backup restored" > $LOG_FILE
else
  echo "[$TIMESTAMP] No backup found" > $LOG_FILE
  exit 1
fi

