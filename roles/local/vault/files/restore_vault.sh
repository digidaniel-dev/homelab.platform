#!/bin/bash
set -e

export VAULT_ADDR=http://127.0.0.1:8200

if [ -f /var/backups/vault/latest/vault.backup ]; then
  vault operator raft snapshot restore /var/backups/vault/latest/vault.backup
  echo "restored"
else
  echo "no backup found"
  exit 1
fi

