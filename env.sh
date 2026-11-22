#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: source $0 <directory-name>"
    return 1 2>/dev/null || exit 1
fi

FILE_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$1/.env"

if [ -f "$FILE_PATH" ]; then
    set -a
    source "$FILE_PATH"
    set +a

    echo "Environment variables loaded from $FILE_PATH"
else
    echo "Warning: .env file does not exist: $FILE_PATH"
    return 1 2>/dev/null || exit 1
fi