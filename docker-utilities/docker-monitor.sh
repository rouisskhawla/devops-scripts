#!/bin/bash

LOG_DIR="/var/log/docker-monitor"
DATE=$(date +%Y-%m-%d)
TIME=$(date +%H-%M-%S)
LOG_FILE="$LOG_DIR/docker-monitor-$DATE.log"

CLEANUP_DAYS=30

mkdir -p "$LOG_DIR"

echo "[$(date)] Container stats snapshot:" >> "$LOG_FILE"

docker stats --no-stream \
  --format "{{.Name}},{{.CPUPerc}},{{.MemUsage}}" >> "$LOG_FILE"

echo "" >> "$LOG_FILE"

find "$LOG_DIR" -type f -name "*.log" -mtime +$CLEANUP_DAYS -exec rm -f {} \;