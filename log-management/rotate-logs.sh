#!/bin/bash

LOG_DIR="/home/ubuntu/project/log"
LOG_ARCHIVE_DIR="/home/ubuntu/project/archive"
YESTERDAY=$(date -d "yesterday" +%Y-%m-%d)
YESTERDAY_FOLDER=$(date -d "yesterday" +%Y%m%d)

mkdir -p "$LOG_ARCHIVE_DIR/$YESTERDAY_FOLDER"

find "$LOG_DIR" -maxdepth 1 -type f -name "server.log.$YESTERDAY-*" | while read -r file; do
    echo "Moving $file to $LOG_ARCHIVE_DIR/$YESTERDAY_FOLDER/"
    mv "$file" "$LOG_ARCHIVE_DIR/$YESTERDAY_FOLDER/"
done

if [ -d "$LOG_ARCHIVE_DIR/$YESTERDAY_FOLDER" ]; then
    echo "Compressing logs to $LOG_ARCHIVE_DIR/server-logs-$YESTERDAY_FOLDER.tar.gz"
    tar -czf "$LOG_ARCHIVE_DIR/server-logs-$YESTERDAY_FOLDER.tar.gz" -C "$LOG_ARCHIVE_DIR" "$YESTERDAY_FOLDER"

    if [ $? -eq 0 ]; then
        echo "Removing $LOG_ARCHIVE_DIR/$YESTERDAY_FOLDER"
        rm -rf "$LOG_ARCHIVE_DIR/$YESTERDAY_FOLDER"
    else
        echo "Compression failed. Folder not removed."
    fi
fi

echo "Deleting compressed log archives older than 15 days"
find "$LOG_ARCHIVE_DIR" -type f -name "server-logs-*.tar.gz" -mtime +15 -exec rm -f {} \;
