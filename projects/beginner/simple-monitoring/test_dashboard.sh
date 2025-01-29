#!/bin/bash

########
# Version: v1
#
# Test system and Netstat dashboard
#
# This script stress-loads the CPU in order to check the correct function of the Netstat dashboard and alert system
########

set -euo pipefail

# Define a log file
LOG_FILE="/var/log/netdata_dashboard_test.log"

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

# Function to install test tools
install_test_tools() {
    log "Starting test tool installation..."

    # Update system packages
    log "Updating system..."
    apt update -y >> "$LOG_FILE" 2>&1 || {
        log "ERROR: System update failed"
        exit 1
    }

    # Install test tools packages
    log "Installing test tools..."
    apt install -y stress-ng iperf3 >> "$LOG_FILE" 2>&1 || {
        log "ERROR: Failed to install test tools"
        exit 1
    }

    log "Test tools successfully installed"
}

# Function to run tests
run_tests() {
    log "Starting system load test..."

    # CPU Test
    log "Testing CPU load..."
    stress-ng --cpu 2 --timeout 30 >> "$LOG_FILE" 2>&1
    log "CPU load test completed"

    # Memory Test
    log "Testing memory usage..."
    stress-ng --vm 1 --vm-bytes 1G --timeout 30 >> "$LOG_FILE" 2>&1
    log "Memory test completed"

    # Disk I/O Test
    log "Testing disk I/O..."
    mkdir -p ~/io-test
    cd ~/io-test
    stress-ng --io 2 --timeout 30 >> "$LOG_FILE" 2>&1
    dd if=/dev/zero of=testfile bs=1M count=1000 >> "$LOG_FILE" 2>&1
    log "Disk I/O test completed"

    # Network Test
    log "Testing network..."
    iperf3 -s -D >> "$LOG_FILE" 2>&1
    sleep 2 # Give the system time to start
    iperf3 -c localhost >> "$LOG_FILE" 2>&1
    pkill -f iperf3
    log "Network test completed"

    # Combined Load Test
    log "Starting combined CPU, memory and disk I/O test..."
    stress-ng --cpu 2 --vm 1 --vm-bytes 512M --io 2 --timeout 60 >> "$LOG_FILE" 2>&1
    log "Combined load test completed"

    log "All tests completed"
}

main() {
    # Create log file
    touch "$LOG_FILE"
    chmod 644 "$LOG_FILE"

    # Run checks
    is_root

    # Install test tools
    install_test_tools

    # Run tests
    run_tests

    log "Test tool installation complete and tests executed successfully"
}

main
