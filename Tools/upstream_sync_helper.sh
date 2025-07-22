#!/bin/bash

# Upstream Sync Helper Script
# This script helps identify and apply upstream changes to the Liminality Project fork

set -e

UPSTREAM_REMOTE="upstream"
UPSTREAM_REPO="https://github.com/space-wizards/space-station-14.git"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Liminality Project Upstream Sync Helper${NC}"
echo "=========================================="

# Check if upstream remote exists
if ! git remote get-url $UPSTREAM_REMOTE >/dev/null 2>&1; then
    echo -e "${YELLOW}Adding upstream remote...${NC}"
    git remote add $UPSTREAM_REMOTE $UPSTREAM_REPO
fi

echo -e "${YELLOW}Fetching latest upstream changes...${NC}"
git fetch $UPSTREAM_REMOTE

# Get the last merge date from git log
LAST_MERGE_DATE=$(git log --grep="upstream" --format="%ad" --date=short -1 2>/dev/null || echo "2025-02-12")
echo -e "Last upstream merge: ${GREEN}$LAST_MERGE_DATE${NC}"

echo -e "\n${YELLOW}Recent upstream commits since last merge:${NC}"
git log --oneline --since="$LAST_MERGE_DATE" $UPSTREAM_REMOTE/master | head -20

echo -e "\n${YELLOW}Potential cherry-pick candidates (bug fixes):${NC}"
git log --oneline --since="$LAST_MERGE_DATE" --grep="fix\|Fix\|BUGFIX\|bug" $UPSTREAM_REMOTE/master | head -10

echo -e "\n${YELLOW}Security-related commits:${NC}"
git log --oneline --since="$LAST_MERGE_DATE" --grep="security\|Security\|CVE\|vulnerability" $UPSTREAM_REMOTE/master | head -5

echo -e "\n${GREEN}Usage Examples:${NC}"
echo "To cherry-pick a commit: git cherry-pick <commit-hash>"
echo "To view a commit: git show <commit-hash>"
echo "To check if file exists: ls <file-path>"

echo -e "\n${YELLOW}Notes:${NC}"
echo "- Test each cherry-pick individually"
echo "- Avoid commits that modify core game systems"
echo "- Focus on bug fixes and security improvements"
echo "- Check for conflicts with DeltaV/Liminality functionality"