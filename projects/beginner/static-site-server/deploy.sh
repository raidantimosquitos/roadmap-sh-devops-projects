#!/bin/bash

set -eo pipefail

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOCAL_DIR="$SCRIPT_DIR/tutorial"
REMOTE_USER="lucash"   # SSH username on the server
REMOTE_HOST=178.128.105.150   # Server IP or domain
REMOTE_DIR="/srv/www"  # Destination directory on the server

# Function to check if the last command succeeded
check_success() {
    if [ $? -ne 0 ]; then
        echo "ERROR: $1"
        exit 1
    fi
}

main() {
    echo "Deploying to $REMOTE_USER@$REMOTE_HOST..."

    # Ensure the directory in the remote server exists
    echo "Checking directory status on remote server..."
    if ! ssh "$REMOTE_USER@$REMOTE_HOST" "[ -d '$REMOTE_DIR' ]"; then
        echo "Directory in remote server does not exist, I will create it. You should be prompted soon for your $REMOTE_USER@$REMOTE_HOST sudo password..."
        ssh -t "$REMOTE_USER@$REMOTE_HOST" "
            sudo mkdir -p '$REMOTE_DIR/tutorial'
        "
        check_success "Failed to create remote directory!"
    fi

    # Sync files locally -> remote
    echo "Syncing files..."
    rsync -avz --delete \
        --exclude '.git' \
        --exclude 'node_modules' \
        --exclude '.DS_Store' \
        -e "ssh" \
        "$LOCAL_DIR/" \
        "$REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR/tutorial/" \
        --rsync-path="sudo rsync"
    check_success "rsync failed!"

    # Remote: Set permissions and restart Nginx
    echo "Updating permissions and restarting Nginx..."
    ssh "$REMOTE_USER@$REMOTE_HOST" "
        sudo restricted_cmds chown -R www-data:www-data '$REMOTE_DIR/tutorial'
        sudo restricted_cmds chmod -R 755 '$REMOTE_DIR/tutorial'
        sudo systemctl restart nginx
    "
    check_success "Remote commands failed!"

    echo "Deployment complete!"
}

main
