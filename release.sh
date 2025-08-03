#!/bin/bash
#
# Git-Go Release Script
# Automates version updates, commits, and releases
#

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

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

warning() {
    echo -e "${YELLOW}⚠️  $*${NC}"
}

# Header
echo -e "${BOLD}Git-Go Release Tool${NC}\n"

# Check if we're in the git-go directory
if [[ ! -f "bin/git-go" ]]; then
    error "Must run from git-go root directory"
fi

# Check for changes and handle them
info "Checking for uncommitted changes..."

# Add any untracked files that aren't gitignored
UNTRACKED=$(git ls-files --others --exclude-standard)
if [[ -n "$UNTRACKED" ]]; then
    info "Adding untracked files..."
    echo "$UNTRACKED" | while read -r file; do
        echo "  + $file"
        git add "$file"
    done
fi

# Check for any staged or modified files
if ! git diff-index --quiet HEAD --; then
    warning "You have uncommitted changes. Reviewing..."
    echo
    git status --short
    echo
    read -p "Include these changes in the release? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        info "Adding all changes..."
        git add -A
    else
        error "Please commit or stash your changes first."
    fi
fi

# Get current version
CURRENT_VERSION=$(grep 'VERSION=' bin/git-go | cut -d'"' -f2)
info "Current version: $CURRENT_VERSION"

# Parse version components
IFS='.' read -r MAJOR MINOR PATCH <<< "$CURRENT_VERSION"

# Ask for version bump type
echo
echo "What type of release is this?"
echo "  1) Patch (bug fixes)     - $MAJOR.$MINOR.$((PATCH + 1))"
echo "  2) Minor (new features)  - $MAJOR.$((MINOR + 1)).0"
echo "  3) Major (breaking)      - $((MAJOR + 1)).0.0"
echo "  4) Custom version"
echo
read -p "Select (1-4): " RELEASE_TYPE

case $RELEASE_TYPE in
    1)
        NEW_VERSION="$MAJOR.$MINOR.$((PATCH + 1))"
        RELEASE_DESC="Patch release with bug fixes and minor improvements"
        ;;
    2)
        NEW_VERSION="$MAJOR.$((MINOR + 1)).0"
        RELEASE_DESC="Minor release with new features"
        ;;
    3)
        NEW_VERSION="$((MAJOR + 1)).0.0"
        RELEASE_DESC="Major release with breaking changes"
        ;;
    4)
        read -p "Enter custom version: " NEW_VERSION
        read -p "Brief description: " RELEASE_DESC
        ;;
    *)
        error "Invalid selection"
        ;;
esac

info "New version will be: $NEW_VERSION"

# Update version in main script
sed -i "s/VERSION=\"$CURRENT_VERSION\"/VERSION=\"$NEW_VERSION\"/" bin/git-go
success "Updated version in bin/git-go"

# Generate commit message based on changes
info "Analyzing changes since last release..."

# Get the last tag
LAST_TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo "")

# Collect changes
CHANGES=""
if [[ -n "$LAST_TAG" ]]; then
    # Get list of commits since last tag
    COMMITS=$(git log --oneline "$LAST_TAG"..HEAD --pretty=format:"- %s" | grep -v "^- Merge" || true)
    if [[ -n "$COMMITS" ]]; then
        CHANGES="\n\nChanges:\n$COMMITS"
    fi
else
    CHANGES="\n\nInitial release"
fi

# Create detailed commit message
COMMIT_MSG="Release v${NEW_VERSION}: ${RELEASE_DESC}${CHANGES}

Version bump from ${CURRENT_VERSION} to ${NEW_VERSION}"

# Show the commit message
echo
echo -e "${BOLD}Commit message:${NC}"
echo "$COMMIT_MSG"
echo

# Confirm
read -p "Proceed with commit and release? (y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    # Revert version change
    sed -i "s/VERSION=\"$NEW_VERSION\"/VERSION=\"$CURRENT_VERSION\"/" bin/git-go
    warning "Release cancelled. Version reverted."
    exit 0
fi

# Commit changes
info "Committing changes..."
git add bin/git-go
git commit -m "$COMMIT_MSG"
success "Changes committed"

# Create tag
info "Creating tag v${NEW_VERSION}..."
git tag -a "v${NEW_VERSION}" -m "${RELEASE_DESC}"
success "Tag created"

# Push to GitHub
info "Pushing to GitHub..."
if git remote | grep -q "^github$"; then
    git push github main
    git push github "v${NEW_VERSION}"
    success "Pushed to GitHub"
else
    warning "No 'github' remote found. You'll need to push manually:"
    echo "  git push origin main"
    echo "  git push origin v${NEW_VERSION}"
fi

# Wait a moment for GitHub to process
echo
info "Waiting for GitHub to process the push..."
sleep 3

# Run install.sh to test the installation
echo
echo -e "${BOLD}Testing installation from GitHub...${NC}"
echo

# Clean up any existing test installation
rm -rf ~/.local/share/git-go-test ~/.local/bin/git-go-test

# Run install.sh with test paths
INSTALL_DIR="$HOME/.local/share/git-go-test" \
BIN_DIR="$HOME/.local/bin" \
./install.sh

# Test the installed version
echo
info "Testing installed version..."
if [[ -f ~/.local/bin/git-go ]]; then
    INSTALLED_VERSION=$(~/.local/bin/git-go version | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')
    if [[ "$INSTALLED_VERSION" == "$NEW_VERSION" ]]; then
        success "Installation test passed! Version $NEW_VERSION is working."
    else
        error "Version mismatch! Expected $NEW_VERSION but got $INSTALLED_VERSION"
    fi
else
    error "Installation test failed - git-go not found"
fi

# Clean up test installation
rm -rf ~/.local/share/git-go-test

echo
success "Release v${NEW_VERSION} completed successfully!"
echo
echo -e "${BOLD}Next steps:${NC}"
echo "  1. Create a GitHub release at: https://github.com/PowerAppsDarren/git-go/releases/new"
echo "  2. Share the install command: curl -sSL https://raw.githubusercontent.com/PowerAppsDarren/git-go/main/install.sh | bash"
echo