#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'  # No Color
BOLD='\033[1m'

SCRIPT_NAME=$1
USER_ID=$(id -u)

echo "Checking LaunchAgent status..."
exit_code=$(launchctl print gui/$USER_ID/$SCRIPT_NAME 2>/dev/null | grep "last exit code" | awk '{print $5}')

if [ "$exit_code" = "0" ]; then
    echo -e "${GREEN}${BOLD}✓ LaunchAgent status: OK (exit code: 0)${NC}"
elif [ "$exit_code" = "(never run)" ]; then
    echo -e "${RED}${BOLD}! LaunchAgent status: Never run${NC}"
elif [ -n "$exit_code" ]; then
    echo -e "${RED}${BOLD}✗ LaunchAgent failed with exit code: $exit_code${NC}"
    error_msg=$(launchctl error "$exit_code" 2>&1)
    echo -e "${RED}Error code: $exit_code${NC}"
    echo -e "${RED}Error details: $error_msg${NC}"
else
    echo -e "${RED}${BOLD}! LaunchAgent status: Not running or not found${NC}"
fi 