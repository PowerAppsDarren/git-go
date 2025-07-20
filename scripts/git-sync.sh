#!/bin/bash
#
# Sync script for git-go
# Pushes to all remotes
#

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${YELLOW}🔄 Syncing git-go...${NC}"

# Check for uncommitted changes
if ! git diff-index --quiet HEAD --; then
    echo -e "${RED}⚠️  You have uncommitted changes. Please commit or stash them first.${NC}"
    exit 1
fi

# Detect current branch
current_branch=$(git rev-parse --abbrev-ref HEAD)

# Push to all remotes
echo -e "${YELLOW}📤 Pushing to all remotes...${NC}"
git push origin ${current_branch}
git push alt ${current_branch}

echo -e "${GREEN}✅ Sync complete!${NC}"
