#!/bin/bash

# Run Love2D 0.9.1 with timeout
echo "Running Lizard Journey with Love2D 0.9.1 (5 second timeout)..."
timeout 5s ./vendor/love2d-0.9.1-win64/love.exe love2d/

EXIT_CODE=$?

if [ $EXIT_CODE -eq 124 ]; then
    echo "=== Game terminated after 5 second timeout ==="
elif [ $EXIT_CODE -eq 0 ]; then
    echo "=== Game exited successfully ==="
else
    echo "=== Game exited with error code: $EXIT_CODE ==="
fi