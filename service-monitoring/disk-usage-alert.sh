#!/bin/bash

THRESHOLD=85
EMAIL=""
LOGFILE="/var/log/disk_alert.log"

HOSTNAME=$(/bin/hostname)
IPADDR=$(/bin/hostname -I | /usr/bin/awk '{print $1}')
USAGE=$(/bin/df -h / | /usr/bin/awk 'NR==2 {gsub("%","",$5); print $5}')

echo "[$(date)] Running check, usage=${USAGE}%, threshold=${THRESHOLD}" >> $LOGFILE

if [ "$USAGE" -ge "$THRESHOLD" ]; then
    SUBJECT="Disk Alert: $HOSTNAME usage at ${USAGE}%"
    MESSAGE=$(cat <<EOF
Hello,

This is an automated alert from server $HOSTNAME.

Disk Usage Alert:
The root partition (/) has reached ${USAGE}% usage.

Server Details:
- Hostname: $HOSTNAME
- IP Address: $IPADDR

Recommended Action:
Please review disk space usage and free up unnecessary files to avoid potential issues.

Regards,
Disk Monitoring System
EOF
)
    /usr/bin/mail -s "$SUBJECT" "$EMAIL" <<< "$MESSAGE"

    echo "[$(date)] Alert sent to $EMAIL" >> $LOGFILE
else
    echo "[$(date)] Usage OK, no alert sent" >> $LOGFILE
fi
