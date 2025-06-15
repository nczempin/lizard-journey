#!/bin/bash

# Set up paths
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
LOVE_DIR="$SCRIPT_DIR/love-0.9.1"
LOVE_BIN="$LOVE_DIR/usr/bin/love"
LOVE_LIB="$LOVE_DIR/usr/lib/x86_64-linux-gnu"

# Check if files exist
if [ ! -f "$LOVE_BIN" ]; then
    echo "Error: LÖVE 0.9.1 binary not found at $LOVE_BIN"
    exit 1
fi

if [ ! -d "$LOVE_LIB" ]; then
    echo "Error: LÖVE 0.9.1 libraries not found at $LOVE_LIB"
    exit 1
fi

# Set library path
export LD_LIBRARY_PATH="$LOVE_LIB:$LD_LIBRARY_PATH"

# Run with timeout
echo "Running Lizard Journey with LÖVE 0.9.1 (5 second timeout)..."
echo "Library path: $LOVE_LIB"
echo ""

timeout 5s "$LOVE_BIN" love2d/ 2>&1

EXIT_CODE=$?

if [ $EXIT_CODE -eq 124 ]; then
    echo ""
    echo "=== Game terminated after 5 second timeout ==="
elif [ $EXIT_CODE -eq 0 ]; then
    echo ""
    echo "=== Game exited successfully ==="
else
    echo ""
    echo "=== Game exited with error code: $EXIT_CODE ==="
fi