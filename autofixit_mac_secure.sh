#!/bin/zsh

# AutoFixIT-mac: A macOS Help Desk Diagnostic Script with Security Checks
# Author: General release
# Description: Diagnoses system issues, logs results, performs optional fixes, and runs security audits

LOG_DIR="./logs"
LOG_FILE="$LOG_DIR/report_$(date +%Y-%m-%d_%H-%M-%S).txt"
mkdir -p "$LOG_DIR"
touch "$LOG_FILE"

log() {
    echo "$(date +%Y-%m-%d\ %H:%M:%S) - $1" | tee -a "$LOG_FILE"
}

log "==================== Starting AutoFixIT diagnostics ===================="

# 1. Internet connectivity check
if ping -c 2 8.8.8.8 >/dev/null 2>&1; then
    log "✅ Internet connection: OK"
else
    log "❌ Internet connection: FAILED"
fi

# 2. DNS resolution check
log "Running DNS resolution check..."
dns_check=$(scutil --dns | grep "nameserver\[[0-9]*\]" | awk '{print $3}')
if [[ -n "$dns_check" ]]; then
    log "✅ DNS resolver found: $dns_check"
else
    log "❌ DNS resolution appears misconfigured"
fi

# 3. Disk space check
disk_use=$(df -h / | awk 'NR==2 {print $5}')
log "Disk usage on / is $disk_use"
if [[ ${disk_use%\%} -gt 85 ]]; then
    log "⚠️ Warning: Disk usage is high!"
else
    log "✅ Disk usage is within normal range"
fi

# 4. Optional Wi-Fi restart
read "restart_net?Do you want to restart Wi-Fi to attempt fix? (y/n): "
if [[ "$restart_net" == "y" ]]; then
    log "Restarting Wi-Fi service..."
    networksetup -setnetworkserviceenabled Wi-Fi off
    sleep 2
    networksetup -setnetworkserviceenabled Wi-Fi on
    log "✅ Wi-Fi service restarted"
fi

# 5. System logs
log "Fetching recent system errors..."
log_output=$(log show --style syslog --last 2m | grep -i "error" | head -n 5)
log "$log_output"

# ================== SECURITY CHECKS ==================
log "==================== Starting Security Checks ===================="

# 6. Firewall status
fw_status=$(defaults read /Library/Preferences/com.apple.alf globalstate)
if [ "$fw_status" -eq 1 ]; then
    log "✅ Firewall is ENABLED"
else
    log "❌ Firewall is DISABLED"
fi

# 7. SIP status
sip_status=$(csrutil status 2>/dev/null)
log "System Integrity Protection: $sip_status"

# 8. Login items
log "🔍 Checking login items..."
osascript -e 'tell application "System Events" to get the name of every login item' >> "$LOG_FILE"

# 9. Open network ports
log "🌐 Open network ports (showing top 5):"
lsof -i -P | grep LISTEN | awk '{print $1, $9}' | sort -u | head -n 5 >> "$LOG_FILE"

# 10. World-writable files (limited to 5 results)
log "🔒 Checking for world-writable files..."
find / -type f -perm -002 -ls 2>/dev/null | head -n 5 >> "$LOG_FILE"

log "==================== Diagnostics complete ===================="
log "Log saved to $LOG_FILE"
echo "Done! View your report: $LOG_FILE"
