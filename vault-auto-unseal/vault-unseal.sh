#!/usr/bin/env bash
set -e
source /etc/vault.d/vault.env

for i in {1..30}; do
  if vault status >/dev/null 2>&1; then break; fi
  sleep 2
done

if vault status | grep -q 'Sealed.*false'; then exit 0; fi

while read -r key; do
  vault operator unseal "$key" || true
  sleep 1
done < /opt/vault/unseal_keys.txt