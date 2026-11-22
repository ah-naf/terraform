#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <directory-name>"
    exit 1
fi

FILE_PATH="$(pwd)/$1/.env"

if [ -f "$FILE_PATH" ]; then
    set -a
    source "$FILE_PATH"
    set +a

    echo "Environment variables loaded from $FILE_PATH"
else
    echo "Warning: .env file does not exist: $FILE_PATH"
    exit 1
fi