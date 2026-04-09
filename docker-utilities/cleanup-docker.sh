#!/bin/bash

LOG_DIR="/var/log/docker-cleanup"
DATE=$(date +%Y-%m-%d)
LOG_FILE="$LOG_DIR/docker-cleanup-$DATE.log"

CLEANUP_DAYS=30

mkdir -p "$LOG_DIR"

echo "[$(date)] Starting scheduled Docker cleanup..." >> "$LOG_FILE"

echo "[$(date)] Disk usage BEFORE cleanup:" >> "$LOG_FILE"
docker system df >> "$LOG_FILE" 2>&1

docker system prune -a -f >> "$LOG_FILE" 2>&1

echo "[$(date)] Disk usage AFTER cleanup:" >> "$LOG_FILE"
docker system df >> "$LOG_FILE" 2>&1

echo "[$(date)] Cleanup completed." >> "$LOG_FILE"

find "$LOG_DIR" -type f -name "*.log" -mtime +$CLEANUP_DAYS -exec rm -f {} \;