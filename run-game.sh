#!/bin/bash

# Run the game with a timeout
echo "Starting Lizard Journey with 10 second timeout..."
echo "Note: This game was made for LÖVE 0.9.1 but we're running it with $(love --version 2>&1)"
echo ""

# Use timeout command to limit execution
timeout 10s love love2d/

EXIT_CODE=$?

if [ $EXIT_CODE -eq 124 ]; then
    echo ""
    echo "Game was terminated after 10 seconds timeout."
elif [ $EXIT_CODE -ne 0 ]; then
    echo ""
    echo "Game exited with error code: $EXIT_CODE"
fi