#!/bin/bash
#
# Deploy script for git-go
# Creates a launcher in ~/bin/ for easy access
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
MAIN_SCRIPT="${SCRIPT_DIR}/bin/git-go"
USER_BIN_DIR="${HOME}/bin"
LAUNCHER="${USER_BIN_DIR}/git-go"

# Check if main script exists
if [ ! -f "$MAIN_SCRIPT" ]; then
    echo -e "${RED}❌ Error: bin/git-go not found in ${SCRIPT_DIR}${NC}"
    exit 1
fi

# Make sure main script is executable
chmod +x "$MAIN_SCRIPT"
echo -e "${GREEN}✓ Main script is executable${NC}"

# Create user bin directory if needed
mkdir -p "$USER_BIN_DIR"

# Create/update the launcher
echo -e "${YELLOW}📝 Creating launcher...${NC}"
cat > "$LAUNCHER" << EOF
#!/bin/bash
# Git-Go launcher
exec "$MAIN_SCRIPT" "\$@"
EOF

# Make launcher executable
chmod +x "$LAUNCHER"
echo -e "${GREEN}✓ Launcher created at ${LAUNCHER}${NC}"

# Create gitgo alias
GITGO_ALIAS="${USER_BIN_DIR}/gitgo"
if [[ ! -e "$GITGO_ALIAS" ]]; then
    ln -s "$LAUNCHER" "$GITGO_ALIAS"
    echo -e "${GREEN}✓ Created gitgo alias${NC}"
elif [[ -L "$GITGO_ALIAS" ]]; then
    echo -e "${GREEN}✓ gitgo alias already exists${NC}"
else
    echo -e "${YELLOW}⚠️  gitgo exists but is not a symlink${NC}"
fi

# Check if ~/bin is in PATH
if [[ ":$PATH:" != *":$USER_BIN_DIR:"* ]]; then
    echo
    echo -e "${YELLOW}⚠️  ${USER_BIN_DIR} is not in your PATH${NC}"
    echo
    echo "Add this to your ~/.bashrc or ~/.zshrc:"
    echo "  export PATH=\"\$HOME/bin:\$PATH\""
else
    echo -e "${GREEN}✓ ${USER_BIN_DIR} is in PATH${NC}"
fi

# Create initial config if needed
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/git-go"
if [[ ! -f "$CONFIG_DIR/config" ]]; then
    echo
    echo -e "${YELLOW}📝 No configuration found${NC}"
    echo
    echo "To get started, run: ${BLUE}git-go config${NC}"
    echo "This will create a configuration file with examples."
    echo
    echo "Or copy the example manually:"
    echo "  cp $SCRIPT_DIR/config/git-go.conf.example $CONFIG_DIR/config"
fi

# Verify deployment
if [ -x "$LAUNCHER" ]; then
    echo
    # Run tests
echo
echo -e "${BLUE}Running tests...${NC}"
if ./tests/run_tests.sh; then
    echo -e "${GREEN}✓ Tests passed${NC}"
else
    echo -e "${YELLOW}⚠️  Some tests failed (see above)${NC}"
fi

echo
echo -e "${GREEN}✅ Deployment successful!${NC}"
    echo
    echo -e "${BLUE}You can now run git-go from anywhere:${NC}"
    echo -e "  ${YELLOW}git-go new --name my-project${NC}"
    echo -e "  ${YELLOW}git-go fork --url https://github.com/user/repo${NC}"
    echo -e "  ${YELLOW}git-go config${NC}"
    echo
    echo -e "${BLUE}The launcher will use the version from:${NC}"
    echo -e "  ${YELLOW}${MAIN_SCRIPT}${NC}"
else
    echo -e "${RED}❌ Deployment failed!${NC}"
    exit 1
fi