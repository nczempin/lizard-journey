#!/bin/bash

echo "Testing mouse button compatibility fixes..."
echo "The game will run for 30 seconds to test mouse interactions."
echo "Try the following:"
echo "- Left click: Set goal for the lizard"
echo "- Middle click and drag: Pan the camera"
echo "- Mouse wheel: Zoom in/out"
echo ""
echo "Starting the game..."

# Run the game with a timeout
timeout 30s love love2d/

echo ""
echo "Test completed. If no errors appeared, the mouse button fixes are working correctly."