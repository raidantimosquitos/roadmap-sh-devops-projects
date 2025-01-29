#!/bin/bash

########
# Version: v1
#
# Clean-up the system
#
# This script uninstalls Netdata and cleans the system
########

set -euo pipefail

# Define a log file
LOG_FILE="/var/log/netdata_cleanup.log"

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

# Function to cleanup the system
cleanup() {
    log "Starting cleanup procedure..."

    # Stop Netdata service
    log "Stopping Netdata systemd service..."
    systemctl stop netdata || log "WARNING: Failed to stop Netdata service"

    # Remove Netdata package
    log "Removing Netdata package..."
    apt remove netdata -y >> "$LOG_FILE" 2>&1 || log "WARNING: Failed to remove Netdata package"

    # Remove data and configuration directories
    rm -rf /etc/netdata
    rm -rf /var/cache/netdata
    rm -rf /var/lib/netdata
    rm -rf /var/log/netdata

    # Remove test tools
    log "Removing test tools..."
    apt remove stress-ng iperf3 -y >> "$LOG_FILE" 2>&1 || log "WARNING: Failed to remove test tools"

     # Clean up test files
    log "Cleaning up test files..."
    rm -rf ~/io-test
    rm -f /tmp/testfile
    rm -f /tmp/netdata-kickstart.sh

    # List all dpkg-statoverride entries and filter for "netdata" user or group
    log "Cleaning dpkg-statoverride database entries..."
    sudo dpkg-statoverride --list | grep 'netdata' | awk '{print $4}' | while read -r dir; do
        # Remove each directory override
        sudo dpkg-statoverride --remove "$dir"
    done
    log "dpkg-statoverride entries successfuly removed"

    # Remove Netdata user and group
    log "Removing Netdata user and group..."
    userdel netdata 2>/dev/null || log "Warning: Netdata user not found"
    groupdel netdata 2>/dev/null || log "Warning: Netdata group not found"
    log "Netdata user and group successfuly removed"

    # Clean package cache
    log "Cleaning package cache..."
    apt clean all >> "$LOG_FILE" 2>&1
    log "Package cache successfuly cleaned"

    # Verify cleanup
    log "Verifying cleanup..."
    if systemctl is-active --quiet netdata; then
        log "Warning: Netdata service is still active"
    else
        log "Netdata service successfully removed"
    fi

    log "Cleanup completed successfully"
}

# Main execution
main() {
    # Create log file
    touch "$LOG_FILE"
    chmod 644 "$LOG_FILE"

    # Run root-user check
    is_root

    # Cleanup system
    cleanup

    log "System cleanup completed"
}

main
