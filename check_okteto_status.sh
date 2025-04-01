#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'
BOLD='\033[1m'

active_ns=$(okteto namespace list | grep "*" | awk '{print $1}')

if [ -z "$active_ns" ]; then
    echo -e "${RED}${BOLD}! No active namespace found${NC}"
    exit 1
fi

echo -e "Active namespace: ${BOLD}$active_ns${NC}"
status=$(okteto namespace list | grep $active_ns | awk '{print $3}')

if [ "$status" = "Active" ]; then
    echo -e "${GREEN}${BOLD}✓ Namespace status: Active${NC}"
else
    echo -e "${RED}${BOLD}! Namespace status: $status${NC}"
fi 