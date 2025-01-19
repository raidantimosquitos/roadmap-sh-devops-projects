#!/bin/bash

# Input log file
LOG_FILE="nginx-access.log" # Replace with your log file name

# Extract and count top 5 IP addresses
echo "Top 5 IP Addresses:"
awk '{print $1}' "$LOG_FILE" | sort | uniq -c | sort -rn | head -5
echo

# Extract and count top 5 HTTP status codes
echo "Top 5 HTTP Status Codes:"
awk '{print $9}' "$LOG_FILE" | sort | uniq -c | sort -rn | head -5
echo

# Extract and count top 5 requested paths
echo "Top 5 Requested Paths:"
awk -F'"' '{print $2}' "$LOG_FILE" | awk '{print $2}' | sort | uniq -c | sort -rn | head -5
echo

# Extract and count top 5 User Agents
echo "Top 5 User Agents:"
awk -F'"' '{print $6}' "$LOG_FILE" | sort | uniq -c | sort -rn | head -5

