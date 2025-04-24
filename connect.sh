#!/bin/bash
# Quick connect script for Namecheap SSH

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Connecting to Namecheap server...${NC}"
ssh giewjrvx@66.29.146.222 -p21098

# If you've set up the SSH config, you can use this instead:
# ssh namecheap
