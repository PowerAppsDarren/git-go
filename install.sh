#!/bin/bash
#
# Git-Go Installer
#

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

# Configuration
INSTALL_DIR="${INSTALL_DIR:-$HOME/.local/share/git-go}"
BIN_DIR="${BIN_DIR:-$HOME/.local/bin}"
REPO_URL="https://github.com/PowerAppsDarren/git-go.git"

# Functions
error() {
    echo -e "${RED}❌ $*${NC}" >&2
    exit 1
}

success() {
    echo -e "${GREEN}✅ $*${NC}"
}

info() {
    echo -e "${BLUE}ℹ️  $*${NC}"
}

# Header
echo -e "${BOLD}Git-Go Installer${NC}\n"

# Check dependencies
info "Checking dependencies..."
for cmd in git bash; do
    if ! command -v "$cmd" &>/dev/null; then
        error "$cmd is required but not installed"
    fi
done

# Check bash version
BASH_VERSION_MAJOR="${BASH_VERSION%%.*}"
if [[ $BASH_VERSION_MAJOR -lt 4 ]]; then
    error "Bash 4.0+ is required (you have $BASH_VERSION)"
fi

# Create directories
info "Creating directories..."
mkdir -p "$INSTALL_DIR" "$BIN_DIR"

# Download or update
if [[ -d "$INSTALL_DIR/.git" ]]; then
    info "Updating existing installation..."
    cd "$INSTALL_DIR"
    git pull --quiet
else
    info "Downloading Git-Go..."
    git clone --quiet "$REPO_URL" "$INSTALL_DIR"
fi

# Create symlink
info "Installing git-go command..."
ln -sf "$INSTALL_DIR/bin/git-go" "$BIN_DIR/git-go"
chmod +x "$INSTALL_DIR/bin/git-go"

# Check if bin dir is in PATH
if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
    echo
    echo -e "${YELLOW}⚠️  $BIN_DIR is not in your PATH${NC}"
    echo
    echo "Add this to your shell configuration file:"
    echo
    echo "  export PATH=\"\$HOME/.local/bin:\$PATH\""
    echo
    echo "For bash: echo 'export PATH=\"\$HOME/.local/bin:\$PATH\"' >> ~/.bashrc"
    echo "For zsh:  echo 'export PATH=\"\$HOME/.local/bin:\$PATH\"' >> ~/.zshrc"
fi

# Create initial config
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/git-go"
if [[ ! -f "$CONFIG_DIR/config" ]]; then
    info "Creating default configuration..."
    mkdir -p "$CONFIG_DIR"
    cp "$INSTALL_DIR/config/git-go.conf.example" "$CONFIG_DIR/config"
    echo
    echo "Edit your configuration with: git-go config"
fi

# Success
echo
success "Git-Go installed successfully!"
echo
echo -e "${BOLD}Quick Start:${NC}"
echo "  git-go new --name my-project    # Create a new repository"
echo "  git-go fork --url <github-url>  # Fork a repository"
echo "  git-go config                    # Edit configuration"
echo "  git-go help                      # Show help"
echo