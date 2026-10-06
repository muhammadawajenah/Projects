#!/bin/bash

RAM_THRESHOLD=80
DISK_THRESHOLD=80
LOG_FILE="alerts.log"

RAM_USAGE=$(free | awk '/Mem:/ {printf "%d", $3/$2 * 100}')
DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}' | tr -d '%')
NGINX_STATUS=$(systemctl is-active nginx 2>/dev/null || echo "inactive")

BOT_TOKEN="YOUR_BOT_TOKEN_HERE"
CHAT_ID="YOUR_CHAT_ID_HERE"

send_alert() {
    local MESSAGE="$1"
    local TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

echo "[$TIMESTAMP] $MESSAGE" >> "$LOG_FILE"
    echo "[$TIMESTAMP] $MESSAGE"

if [ "$BOT_TOKEN" != "YOUR_BOT_TOKEN_HERE" ]; then
        curl -s -X POST "https://api.telegram.org/bot${BOT_TOKEN}/sendMessage" \
             -d "chat_id=${CHAT_ID}" \
             -d "text=${MESSAGE}" > /dev/null
    fi
}


echo "RAM Usage: ${RAM_USAGE}%"
echo "Disk Usage: ${DISK_USAGE}%"
echo "Nginx Status: ${NGINX_STATUS}"


if [ "$RAM_USAGE" -gt "$RAM_THRESHOLD" ]; then
    send_alert "⚠️ ALERT: RAM Usage is high (${RAM_USAGE}%)"
fi

if [ "$DISK_USAGE" -gt "$DISK_THRESHOLD" ]; then
    send_alert "⚠️ ALERT: Disk Usage is high (${DISK_USAGE}%)"
fi

if [ "$NGINX_STATUS" != "active" ]; then
    send_alert "🚨 ALERT: Nginx Service is DOWN!"
fi
