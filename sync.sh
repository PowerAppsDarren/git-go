#!/bin/bash
# Simple sync script for git-go repository

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${YELLOW}🔄 Syncing git-go repository...${NC}"

# Check for uncommitted changes
if ! git diff-index --quiet HEAD --; then
    echo -e "${RED}⚠️  You have uncommitted changes. Please commit or stash them first.${NC}"
    exit 1
fi

# Get current branch
BRANCH=$(git branch --show-current)

# Push to all remotes
for remote in $(git remote); do
    echo -e "\n${YELLOW}📤 Pushing to $remote...${NC}"
    if git push $remote $BRANCH; then
        echo -e "${GREEN}✓ Pushed to $remote${NC}"
    else
        echo -e "${RED}✗ Failed to push to $remote${NC}"
    fi
done

echo -e "\n${GREEN}✅ Sync complete!${NC}"