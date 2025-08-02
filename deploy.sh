#!/bin/bash
#
# Deploy script for git-go
# Updates the launcher in home directory and ensures proper setup
#

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}=== Git-Go Deploy Script ===${NC}"
echo

# Get the script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
MAIN_SCRIPT="${SCRIPT_DIR}/git-go.sh"
HOME_LAUNCHER="${HOME}/git-go.sh"

# Check if main script exists
if [ ! -f "$MAIN_SCRIPT" ]; then
    echo -e "${RED}❌ Error: git-go.sh not found in ${SCRIPT_DIR}${NC}"
    exit 1
fi

# Make sure main script is executable
chmod +x "$MAIN_SCRIPT"
echo -e "${GREEN}✓ Main script is executable${NC}"

# Create/update the home directory launcher
echo -e "${YELLOW}📝 Creating launcher in home directory...${NC}"
cat > "$HOME_LAUNCHER" << EOF
#!/bin/bash
# Git-Go launcher - runs the actual script from the git-go repository
exec ~/src/git-go/git-go.sh "\$@"
EOF

# Make launcher executable
chmod +x "$HOME_LAUNCHER"
echo -e "${GREEN}✓ Launcher created at ${HOME_LAUNCHER}${NC}"

# Verify deployment
if [ -x "$HOME_LAUNCHER" ]; then
    echo -e "${GREEN}✅ Deployment successful!${NC}"
    echo
    echo -e "${BLUE}You can now run git-go from anywhere:${NC}"
    echo -e "  ${YELLOW}~/git-go.sh${NC}     # From home directory"
    echo -e "  ${YELLOW}./git-go.sh${NC}     # If you're in home directory"
    echo
    echo -e "${BLUE}The launcher will always use the latest version from:${NC}"
    echo -e "  ${YELLOW}${MAIN_SCRIPT}${NC}"
else
    echo -e "${RED}❌ Deployment failed!${NC}"
    exit 1
fi

# Optional: Add to PATH
echo
echo -e "${YELLOW}💡 Tip: To run git-go from anywhere without the path, add this to your ~/.bashrc:${NC}"
echo -e "${BLUE}export PATH=\"\$HOME:\$PATH\"${NC}"
echo -e "${BLUE}Then you can just type: git-go.sh${NC}"