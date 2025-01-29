#!/bin/bash

########
# Version: v1
#
# Set-up Netstat
#
# This script installs and configures Netstat for Ubuntu/Debian systems
########

set -euo pipefail

# Define a log file
LOG_FILE="/var/log/netdata_setup.log"

# Function for registering logs
log() {
    local message="[$(date +'%Y-%m-%d %H:%M:%S')] $1"
    echo "$message" | sudo tee -a "$LOG_FILE"
}

# Function for checking if script is being run as root
is_root() {
    if [[ $EUID -ne 0 ]]; then
        log "ERROR: The script must be ran with root privileges"
        echo "Please run the script with 'sudo' or as the root user"
        exit 2
    fi
}

# Function to install Netdata
install_netdata() {
    log "Starting Netdata installation..."

    # Update system packages
    log "Updating system..."
    apt update -y >> "$LOG_FILE" 2>&1 || {
        log "ERROR: System update failed"
        exit 1
    }

    # Download Netdata
    log "Downloading Netdata..."
    wget -O /tmp/netdata-kickstart.sh https://get.netdata.cloud/kickstart.sh >> "$LOG_FILE" 2>&1 || {
        log "ERROR: Failed to download the Netdata installer"
        exit 1
    }

    # Install Netdata
    log "Installing Netdata..."
    sh /tmp/netdata-kickstart.sh --native-only --non-interactive >> "$LOG_FILE" 2>&1 || {
        log "ERROR: Failed to install Netdata"
        exit 1
    }

    # Start netdata.service
    log "Starting Netdata service..."
    systemctl start netdata >> "$LOG_FILE" 2>&1 || {
        log "ERROR: Starting Netdata failed"
        exit 1
    }

    # Verify installation
    if ! systemctl is-active --quiet netdata; then
        log "ERROR: Netdata service is not running"
        exit 1
    fi

    # Configure Netdata
    log "Configuring Netdata..."
    cat > /etc/netdata/netdata.conf << EOF
[global]
    history = 7200

[web]
    bind to = 0.0.0.0
EOF

    # Create CPU usage alert configuration
    cat > /etc/netdata/health.d/cpu_usage.conf << EOF
alarm: cpu_usage
on: system.cpu
lookup: average -1m unaligned of user,system,softirq,irq,guest
every: 1m
warn: \$this > 80
crit: \$this > 90
info: CPU utilization over 80%
EOF

    # Restart Netdata to apply changes
    systemctl restart netdata >> "$LOG_FILE" 2>&1 || {
        log "ERROR: Failed to restart Netdata"
        exit 1
    }

    log "Installation completed successfully"

}

netdata_server() {
    # retrieve the IP address
    ip_address=$(hostname -I | awk '{print $1}')
    if [[ -z "$ip_address" ]]; then
        log "ERROR: Unable to determine IP address."
        exit 1
    fi

    echo "Check and login on Netdata server on the following address:"
    echo "http://$ip_address:19999"
}

# Main execution
main() {
    # Create log file
    touch "$LOG_FILE"
    chmod 644 "$LOG_FILE"

    # Run root-user check
    is_root

    # Install Netdata
    install_netdata

    # Netdata Server
    netdata_server

    log "Netdata configuration and installation completed"
}

main
