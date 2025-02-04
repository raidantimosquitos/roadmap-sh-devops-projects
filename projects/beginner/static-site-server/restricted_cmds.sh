#!/bin/bash
ALLOWED_DIR="/srv/www/"

if [ "$1" = "chown" ]; then
        if [[ "$4" =~ ^$ALLOWED_DIR(/.*)? ]]; then
                sudo /usr/bin/chown "$2" "$3" "$4"
        else
                echo "ERROR: Operations restricted to $ALLOWED_DIR"
                exit 1
        fi
elif [ "$1" = "chmod" ]; then
        if [[ "$4" =~ ^$ALLOWED_DIR(/.*)? ]]; then
                sudo /usr/bin/chmod "$2" "$3" "$4"
        else
                echo "ERROR: Operations restricted to $ALLOWED_DIR"
                exit 1
        fi
else
        echo "Not permitted command"
        exit 1
fi

