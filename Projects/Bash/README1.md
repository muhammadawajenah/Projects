# Linux System & Service Monitor

This project contains a Bash script designed to monitor system resources, log status alerts, and send automated notifications.

## Main Features
1. **Resource Monitoring:** Tracks RAM, Storage (Disk), and CPU usage.
2. **Service Health Check:** Verifies if the Nginx service is active and running.
3. **Alerting:** Generates local logs and integrates with a Telegram Bot for instant alerts.
4. **Automation:** Scheduled using `cron` for periodic health checks.

---

## Code Breakdown & Explanation

### 1. Resource Thresholds
```bash
RAM_THRESHOLD=80
DISK_THRESHOLD=80
These define the maximum acceptable usage percentage before an alert is triggered.   2. Logging & Telegram IntegrationBashLOG_FILE="alerts.log"
BOT_TOKEN="YOUR_BOT_TOKEN_HERE"
CHAT_ID="YOUR_CHAT_ID_HERE"
The Telegram tokens are kept as configurable placeholders[cite: 2]. If tokens are unavailable, all alerts are safely saved locally to alerts.log with a timestamp[cite: 2].3. Alert FunctionBashsend_alert() {
    local MESSAGE="$1"
    local TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

    echo "[$TIMESTAMP] $MESSAGE" >> "$LOG_FILE"
    echo "[$TIMESTAMP] $MESSAGE"

    if [ "$BOT_TOKEN" != "YOUR_BOT_TOKEN_HERE" ]; then
        curl -s -X POST "[https://api.telegram.org/bot$](https://api.telegram.org/bot$){BOT_TOKEN}/sendMessage" \
             -d "chat_id=${CHAT_ID}" \
             -d "text=${MESSAGE}" > /dev/null
    fi
}
This function logs messages to the local file and dispatches them via API to Telegram when configured[cite: 2].4. System Metrics CollectionBashRAM_USAGE=$(free | awk '/Mem:/ {printf "%d", $3/$2 * 100}')
DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}' | tr -d '%')
NGINX_STATUS=$(systemctl is-active nginx 2>/dev/null)
[ -z "$NGINX_STATUS" ] && NGINX_STATUS="inactive"
Uses core Linux commands (free, df, systemctl) to parse usage percentages as integer values[cite: 2].5. Condition LogicBashif [ "$RAM_USAGE" -gt "$RAM_THRESHOLD" ]; then
    send_alert "⚠️ ALERT: RAM Usage is high (${RAM_USAGE}%)"
fi

if [ "$DISK_USAGE" -gt "$DISK_THRESHOLD" ]; then
    send_alert "⚠️ ALERT: Disk Usage is high (${DISK_USAGE}%)"
fi

if [ "$NGINX_STATUS" != "active" ]; then
    send_alert "🚨 ALERT: Nginx Service is DOWN!"
fi
Triggers send_alert whenever system thresholds are breached or services stop[cite: 2].How to RunMake the script executable:Bashchmod +x monitor.sh
Execute manually:Bash./monitor.sh
Schedule with crontab -e:Plaintext*/5 * * * * /bin/bash /path/to/monitor.sh
