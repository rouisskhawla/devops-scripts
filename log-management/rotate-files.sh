#!/bin/bash

BASE_DIR="/home/ubuntu/project/data"
ARCHIVE_DIR="/home/ubuntu/project/archive"

YESTERDAY=$(date -d "yesterday" +%Y%m%d)

for folder in "$BASE_DIR"/*; do
    if [ -d "$folder" ]; then
        folder_name=$(basename "$folder")

        mkdir -p "$ARCHIVE_DIR/$folder_name/$YESTERDAY"

        find "$folder" -type f -name "${YESTERDAY}*" | while read -r file; do
            echo "Moving $file to $ARCHIVE_DIR/$folder_name/$YESTERDAY/"
            mv "$file" "$ARCHIVE_DIR/$folder_name/$YESTERDAY/"
        done

        echo "Compressing $ARCHIVE_DIR/$folder_name/$YESTERDAY to $ARCHIVE_DIR/$folder_name/${YESTERDAY}.tar.gz"
        tar -czf "$ARCHIVE_DIR/$folder_name/${YESTERDAY}.tar.gz" -C "$ARCHIVE_DIR/$folder_name" "$YESTERDAY"

        if [ $? -eq 0 ]; then
            echo "Removing uncompressed folder $ARCHIVE_DIR/$folder_name/$YESTERDAY"
            rm -rf "$ARCHIVE_DIR/$folder_name/$YESTERDAY"
        else
            echo "Compression failed for $folder_name/$YESTERDAY. Folder not removed."
        fi

        echo "Deleting archive files older than 15 days in $ARCHIVE_DIR/$folder_name"
        find "$ARCHIVE_DIR/$folder_name" -type f -name "*.tar.gz" -mtime +15 -exec rm -f {} \;
    fi
done