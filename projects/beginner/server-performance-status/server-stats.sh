#!/bin/bash

# Display OS version
echo "===== OS Version ====="
cat /etc/os-release | grep -E "PRETTY_NAME" | cut -d= -f2 | tr -d '"'
echo ""

# Display total CPU usage
echo "===== CPU Usage ====="
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | \
            awk '{printf "Used: %.1f%%\n", 100 - $8}')
echo "$CPU_USAGE"
echo ""

# Display total memory usage
echo "===== Memory Usage ====="
MEM_INFO=$(free -h | awk '/^Mem:/ {printf "Used: %s, Free: %s (%.2f%% used)\n", $3, $4, $3*100/($3+$4)}')
echo "$MEM_INFO"
echo ""

# Display total disk usage
echo "===== Disk Usage ====="
DISK_USAGE=$(df -h --total | awk '/^total/ {printf "Used: %s, Free: %s, (%.2f%% used)\n", $3, $4, $3*100/($3+$4)}')
echo "$DISK_USAGE"
echo ""

# Display top 5 processes by CPU usage
echo "===== Top 5 Processes by CPU Usage ====="
ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6
echo ""

# Display top 5 processes by memory usage
echo "===== Top 5 Processes by Memory Usage ====="
ps -eo pid,comm,%mem --sort=-%mem | head -n 6
echo ""

# Display system uptime
echo "===== Uptime ====="
UPTIME=$(uptime -p)
echo "$UPTIME"
echo ""

# Display CPU cores and load average
echo "===== CPU Cores & Load Average ====="
CPU_CORES=$(nproc)
LOAD_AVG=$(uptime | awk -F'load average:' '{print $2}')
echo "NO. CPU CORES: $CPU_CORES"
echo "Load Average:  $LOAD_AVG"
echo "Note: A load average near $CPU_CORES indicates full utilization."
echo ""

# Display logged in users
echo "===== Logged In Users ====="
who | awk '{print $1}' | sort | uniq -c
echo ""

# Display failed login attempts
echo "===== Failed Login Attempts ====="
FAILED_LOGINS=$(grep "Failed password" /var/log/auth.log | wc -l)
echo "Total failed login attempts: $FAILED_LOGINS"
echo ""

# Display open ports and services
echo "===== Open Ports ====="
ss -tuln
echo ""

# Display status of critical services
echo "===== Running Services ====="
systemctl --type=service --state=running | awk '{print $1}'
echo ""

# Display recent critical logs
echo "===== Recent Critical Logs ====="
sudo journalctl -p crit -n 5 --no-pager
echo ""
