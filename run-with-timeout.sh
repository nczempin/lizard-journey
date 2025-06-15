#!/bin/bash

echo "Running Lizard Journey with timeout..."
echo "Press Ctrl+C to stop at any time"
echo ""

# Create a temporary script to capture output
cat > /tmp/run-love.sh << 'EOF'
#!/bin/bash
love love2d/ 2>&1
EOF

chmod +x /tmp/run-love.sh

# Run with timeout and capture output
timeout 5s /tmp/run-love.sh 2>&1 | head -n 50

EXIT_CODE=${PIPESTATUS[0]}

if [ $EXIT_CODE -eq 124 ]; then
    echo ""
    echo "=== Game terminated after 5 second timeout ==="
elif [ $EXIT_CODE -ne 0 ]; then
    echo ""
    echo "=== Game exited with error code: $EXIT_CODE ==="
fi

# Clean up
rm -f /tmp/run-love.sh