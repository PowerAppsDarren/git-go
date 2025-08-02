#!/bin/bash
#
# Interactive Git Repository Setup Script v2.0
# Handles both forking existing repos and creating new ones
# Creates an intelligent sync script for ongoing use
#
# ===================================================================================

set -e  # Exit on error

# Get the real user home directory (not root if using sudo)
if [ -n "$SUDO_USER" ]; then
    USER_HOME=$(getent passwd "$SUDO_USER" | cut -d: -f6)
    REAL_USER="$SUDO_USER"
else
    USER_HOME="$HOME"
    REAL_USER="$USER"
fi

# Configuration
SRC_DIR="${USER_HOME}/src"
DEFAULT_BRANCH="main"  # Can be changed to master if preferred

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Function to check if command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Function to extract author and repo name from URL
extract_repo_info() {
    local url=$1
    local author=""
    local repo=""
    
    # Remove .git suffix if present
    url=${url%.git}
    
    # Handle different URL formats
    if [[ $url =~ github\.com[:/]([^/]+)/([^/]+)$ ]]; then
        author="${BASH_REMATCH[1]}"
        repo="${BASH_REMATCH[2]}"
    elif [[ $url =~ gitlab\.com[:/]([^/]+)/([^/]+)$ ]]; then
        author="${BASH_REMATCH[1]}"
        repo="${BASH_REMATCH[2]}"
    elif [[ $url =~ bitbucket\.org[:/]([^/]+)/([^/]+)$ ]]; then
        author="${BASH_REMATCH[1]}"
        repo="${BASH_REMATCH[2]}"
    elif [[ $url =~ git\.sr\.ht/~([^/]+)/([^/]+)$ ]]; then
        author="${BASH_REMATCH[1]}"
        repo="${BASH_REMATCH[2]}"
    elif [[ $url =~ ([^/:]+)[:/]([^/]+)/([^/]+)$ ]]; then
        author="${BASH_REMATCH[2]}"
        repo="${BASH_REMATCH[3]}"
    fi
    
    echo "$author|$repo"
}

# Function to create enhanced sync script
create_sync_script() {
    local repo_dir=$1
    local repo_name=$2
    local is_fork=$3
    local default_branch=$4
    
    mkdir -p "${repo_dir}/scripts"
    
    cat > "${repo_dir}/scripts/git-sync.sh" << 'EOF'
#!/bin/bash
#
# Enhanced Git Sync Script
# Generated for: REPO_NAME_PLACEHOLDER
# Type: REPO_TYPE_PLACEHOLDER
#

set -e

# Configuration
REPO_NAME="REPO_NAME_PLACEHOLDER"
IS_FORK="IS_FORK_PLACEHOLDER"
DEFAULT_BRANCH="DEFAULT_BRANCH_PLACEHOLDER"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

# Functions
show_status() {
    echo -e "\n${CYAN}📊 Repository Status:${NC}"
    echo -e "   Branch: $(git branch --show-current)"
    echo -e "   Status: $(git status --porcelain | wc -l) uncommitted changes"
    
    if [ "$IS_FORK" = "true" ] && git remote | grep -q "upstream"; then
        local behind=$(git rev-list --count HEAD..upstream/$(git branch --show-current) 2>/dev/null || echo "0")
        local ahead=$(git rev-list --count upstream/$(git branch --show-current)..HEAD 2>/dev/null || echo "0")
        echo -e "   Upstream: ${behind} behind, ${ahead} ahead"
    fi
}

check_remotes() {
    local missing_remotes=()
    
    if [ "$IS_FORK" = "true" ] && ! git remote | grep -q "upstream"; then
        missing_remotes+=("upstream")
    fi
    
    if ! git remote | grep -q "origin"; then
        missing_remotes+=("origin")
    fi
    
    if ! git remote | grep -q "alt"; then
        missing_remotes+=("alt")
    fi
    
    if [ ${#missing_remotes[@]} -gt 0 ]; then
        echo -e "${YELLOW}⚠️  Missing remotes: ${missing_remotes[*]}${NC}"
        echo -e "${YELLOW}   Run 'git remote -v' to check your remotes${NC}"
        return 1
    fi
    
    return 0
}

# Main sync process
echo -e "${BLUE}=== Git Sync for ${REPO_NAME} ===${NC}"

# Show current status
show_status

# Check for uncommitted changes
if ! git diff-index --quiet HEAD -- 2>/dev/null; then
    echo -e "\n${YELLOW}⚠️  You have uncommitted changes:${NC}"
    git status --short
    echo
    read -p "Would you like to stash them? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git stash push -m "Auto-stash before sync $(date +%Y%m%d-%H%M%S)"
        echo -e "${GREEN}✓ Changes stashed${NC}"
        STASHED=true
    else
        echo -e "${RED}❌ Cannot sync with uncommitted changes${NC}"
        exit 1
    fi
fi

# Check remotes
if ! check_remotes; then
    echo -e "${RED}❌ Remote configuration issues detected${NC}"
    exit 1
fi

# Get current branch
current_branch=$(git branch --show-current)

# Handle upstream sync for forks
if [ "$IS_FORK" = "true" ] && git remote | grep -q "upstream"; then
    echo -e "\n${YELLOW}📥 Fetching from upstream...${NC}"
    git fetch upstream
    
    # Check if branch exists on upstream
    if git ls-remote --heads upstream | grep -q "refs/heads/${current_branch}"; then
        # Check if there are updates
        if [ $(git rev-list --count HEAD..upstream/${current_branch} 2>/dev/null || echo "0") -gt 0 ]; then
            echo -e "${YELLOW}📋 New commits from upstream:${NC}"
            git log HEAD..upstream/${current_branch} --oneline --max-count=10
            
            echo
            read -p "Merge these changes? (y/n) " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                echo -e "${YELLOW}🔄 Merging upstream/${current_branch}...${NC}"
                if git merge upstream/${current_branch} -m "Merge upstream changes $(date +%Y-%m-%d)"; then
                    echo -e "${GREEN}✓ Merged successfully${NC}"
                    MERGED_UPSTREAM=true
                else
                    echo -e "${RED}❌ Merge failed - resolve conflicts and run again${NC}"
                    exit 1
                fi
            fi
        else
            echo -e "${GREEN}✓ Already up to date with upstream${NC}"
        fi
    else
        echo -e "${YELLOW}ℹ️  Branch '${current_branch}' doesn't exist on upstream${NC}"
    fi
fi

# Push to remotes
echo -e "\n${YELLOW}📤 Pushing to remotes...${NC}"

# Function to push with retry
push_with_retry() {
    local remote=$1
    local branch=$2
    local attempt=1
    local max_attempts=3
    
    while [ $attempt -le $max_attempts ]; do
        if git push $remote $branch 2>/dev/null; then
            echo -e "${GREEN}✓ Pushed to $remote${NC}"
            return 0
        else
            if [ $attempt -lt $max_attempts ]; then
                echo -e "${YELLOW}⚠️  Push to $remote failed (attempt $attempt/$max_attempts), retrying...${NC}"
                sleep 2
                ((attempt++))
            else
                echo -e "${RED}❌ Failed to push to $remote after $max_attempts attempts${NC}"
                return 1
            fi
        fi
    done
}

# Push to origin
push_with_retry "origin" "$current_branch"

# Push to alt if it exists
if git remote | grep -q "alt"; then
    push_with_retry "alt" "$current_branch"
fi

# Restore stashed changes if any
if [ "${STASHED:-false}" = "true" ]; then
    echo
    read -p "Restore stashed changes? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git stash pop
        echo -e "${GREEN}✓ Stashed changes restored${NC}"
    else
        echo -e "${YELLOW}ℹ️  Stashed changes kept. Use 'git stash pop' to restore later${NC}"
    fi
fi

# Final status
echo
show_status
echo -e "\n${GREEN}✅ Sync complete!${NC}"

# Show helpful commands
echo -e "\n${PURPLE}📝 Helpful commands:${NC}"
echo -e "   git log --oneline -10         # View recent commits"
echo -e "   git status                     # Check working directory"
echo -e "   git stash list                 # View stashed changes"
if [ "$IS_FORK" = "true" ]; then
    echo -e "   git remote update              # Update all remotes"
    echo -e "   git branch -vv                 # Show branch tracking info"
fi
EOF

    # Replace placeholders
    sed -i "s/REPO_NAME_PLACEHOLDER/${repo_name}/g" "${repo_dir}/scripts/git-sync.sh"
    sed -i "s/IS_FORK_PLACEHOLDER/${is_fork}/g" "${repo_dir}/scripts/git-sync.sh"
    sed -i "s/DEFAULT_BRANCH_PLACEHOLDER/${default_branch}/g" "${repo_dir}/scripts/git-sync.sh"
    sed -i "s/REPO_TYPE_PLACEHOLDER/$([ "$is_fork" = "true" ] && echo "Forked Repository" || echo "Original Repository")/g" "${repo_dir}/scripts/git-sync.sh"
    
    chmod +x "${repo_dir}/scripts/git-sync.sh"
    
    # Create a quick sync alias script
    cat > "${repo_dir}/scripts/quick-sync.sh" << 'EOF'
#!/bin/bash
# Quick sync - commits all changes with timestamp and syncs
git add -A
git commit -m "Update: $(date '+%Y-%m-%d %H:%M:%S')" || true
exec "$(dirname "$0")/git-sync.sh"
EOF
    chmod +x "${repo_dir}/scripts/quick-sync.sh"
}

# Function to create VS Code settings
create_vscode_settings() {
    local repo_dir=$1
    
    mkdir -p "${repo_dir}/.vscode"
    
    # Create tasks.json
    cat > "${repo_dir}/.vscode/tasks.json" << 'EOF'
{
    "version": "2.0.0",
    "tasks": [
        {
            "label": "Git Sync",
            "type": "shell",
            "command": "${workspaceFolder}/scripts/git-sync.sh",
            "group": {
                "kind": "build",
                "isDefault": true
            },
            "presentation": {
                "reveal": "always",
                "panel": "terminal",
                "clear": true
            },
            "problemMatcher": []
        },
        {
            "label": "Quick Sync (commit all + sync)",
            "type": "shell",
            "command": "${workspaceFolder}/scripts/quick-sync.sh",
            "presentation": {
                "reveal": "always",
                "panel": "terminal",
                "clear": true
            },
            "problemMatcher": []
        }
    ]
}
EOF

    # Create keybindings recommendation
    cat > "${repo_dir}/.vscode/keybindings.json" << 'EOF'
// Recommended keybindings - copy to your user keybindings.json
[
    {
        "key": "ctrl+alt+s",
        "command": "workbench.action.tasks.runTask",
        "args": "Git Sync"
    },
    {
        "key": "ctrl+alt+q",
        "command": "workbench.action.tasks.runTask",
        "args": "Quick Sync (commit all + sync)"
    }
]
EOF
}

# Main script starts here
echo
echo -e "${BLUE}====================================================================================${NC}"
echo -e "${BLUE}                    Interactive Git Repository Setup v2.0                          ${NC}"
echo -e "${BLUE}====================================================================================${NC}"
echo

# Show current context
echo -e "${YELLOW}Running as user: ${REAL_USER}${NC}"
echo -e "${YELLOW}Repository location: ${SRC_DIR}${NC}"
echo -e "${YELLOW}Default branch: ${DEFAULT_BRANCH}${NC}"
echo

# Check for required tools
missing_tools=()
for tool in git ssh; do
    if ! command_exists "$tool"; then
        missing_tools+=("$tool")
    fi
done

if [ ${#missing_tools[@]} -gt 0 ]; then
    echo -e "${RED}❌ Missing required tools: ${missing_tools[*]}${NC}"
    echo -e "${YELLOW}Please install them first.${NC}"
    exit 1
fi

# Ensure src directory exists
mkdir -p "${SRC_DIR}"

# Ask if forking or creating new
echo -e "${YELLOW}Would you like to fork an existing repository? (y/n)${NC}"
read -p "> " fork_choice

if [[ $fork_choice =~ ^[Yy] ]]; then
    # Forking workflow
    echo
    echo -e "${YELLOW}Enter the URL of the repository to fork:${NC}"
    echo -e "${BLUE}(e.g., https://github.com/author/repo or git@github.com:author/repo.git)${NC}"
    read -p "> " original_url
    
    # Extract author and repo name
    repo_info=$(extract_repo_info "$original_url")
    original_author=$(echo "$repo_info" | cut -d'|' -f1)
    original_repo=$(echo "$repo_info" | cut -d'|' -f2)
    
    if [ -z "$original_author" ] || [ -z "$original_repo" ]; then
        echo -e "${RED}❌ Could not extract repository information from URL${NC}"
        echo -e "${YELLOW}Please enter the author name manually:${NC}"
        read -p "> " original_author
        echo -e "${YELLOW}Please enter the repository name manually:${NC}"
        read -p "> " original_repo
    else
        echo -e "${GREEN}✓ Detected: Author='${original_author}', Repo='${original_repo}'${NC}"
    fi
    
    echo
    echo -e "${YELLOW}Enter your new repository name:${NC}"
    echo -e "${BLUE}(default: ${original_repo})${NC}"
    read -p "> " new_repo_name
    new_repo_name=${new_repo_name:-$original_repo}
    
    # Setup forked repository
    repo_dir="${SRC_DIR}/${new_repo_name}"
    
    if [ -d "$repo_dir" ]; then
        echo -e "${RED}❌ Directory ${repo_dir} already exists!${NC}"
        exit 1
    fi
    
    echo
    echo -e "${GREEN}📋 Summary:${NC}"
    echo -e "  Original URL: ${original_url}"
    echo -e "  New repo name: ${new_repo_name}"
    echo -e "  Location: ${repo_dir}"
    echo
    echo -e "${YELLOW}Proceed? (y/n)${NC}"
    read -p "> " confirm
    
    if [[ ! $confirm =~ ^[Yy] ]]; then
        echo -e "${RED}Cancelled.${NC}"
        exit 0
    fi
    
    # Clone and setup
    echo
    echo -e "${YELLOW}📥 Cloning ${original_url}...${NC}"
    git clone "$original_url" "$repo_dir"
    cd "$repo_dir"
    
    # Detect the default branch
    default_branch=$(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@')
    echo -e "${BLUE}Detected default branch: ${default_branch}${NC}"
    
    echo -e "${YELLOW}🔧 Setting up remotes...${NC}"
    git remote rename origin upstream
    git remote add origin "ssh://git@git.superpowerlabs.app:2222/${REAL_USER}/${new_repo_name}.git"
    git remote add alt "ssh://git@pool:2222/${REAL_USER}/${new_repo_name}.git"
    
    echo -e "${YELLOW}📡 Remote configuration:${NC}"
    git remote -v
    
    echo -e "${YELLOW}📤 Pushing to your repositories...${NC}"
    echo -e "${BLUE}Note: Make sure the remote repositories exist on your git servers${NC}"
    
    # Push to remotes
    if ! git push -u origin "$default_branch" 2>/dev/null; then
        echo -e "${RED}⚠️  Failed to push to origin. Please create the repository first:${NC}"
        echo -e "${YELLOW}   ssh://git@git.superpowerlabs.app:2222/${REAL_USER}/${new_repo_name}.git${NC}"
    else
        echo -e "${GREEN}✓ Pushed to origin${NC}"
    fi
    
    if ! git push -u alt "$default_branch" 2>/dev/null; then
        echo -e "${RED}⚠️  Failed to push to alt. Please create the repository first:${NC}"
        echo -e "${YELLOW}   ssh://git@pool:2222/${REAL_USER}/${new_repo_name}.git${NC}"
    else
        echo -e "${GREEN}✓ Pushed to alt${NC}"
    fi
    
    # Create sync script and VS Code settings
    create_sync_script "$repo_dir" "$new_repo_name" "true" "$default_branch"
    create_vscode_settings "$repo_dir"
    
else
    # New repository workflow
    echo
    echo -e "${YELLOW}Enter the name for your new repository:${NC}"
    read -p "> " new_repo_name
    
    if [ -z "$new_repo_name" ]; then
        echo -e "${RED}❌ Repository name cannot be empty!${NC}"
        exit 1
    fi
    
    # Validate repository name
    if ! [[ "$new_repo_name" =~ ^[a-zA-Z0-9_-]+$ ]]; then
        echo -e "${RED}❌ Repository name can only contain letters, numbers, hyphens, and underscores${NC}"
        exit 1
    fi
    
    repo_dir="${SRC_DIR}/${new_repo_name}"
    
    if [ -d "$repo_dir" ]; then
        echo -e "${RED}❌ Directory ${repo_dir} already exists!${NC}"
        exit 1
    fi
    
    echo
    echo -e "${GREEN}📋 Summary:${NC}"
    echo -e "  New repo name: ${new_repo_name}"
    echo -e "  Location: ${repo_dir}"
    echo -e "  Default branch: ${DEFAULT_BRANCH}"
    echo
    echo -e "${YELLOW}Proceed? (y/n)${NC}"
    read -p "> " confirm
    
    if [[ ! $confirm =~ ^[Yy] ]]; then
        echo -e "${RED}Cancelled.${NC}"
        exit 0
    fi
    
    # Create new repository
    echo
    echo -e "${YELLOW}📁 Creating new repository...${NC}"
    mkdir -p "$repo_dir"
    cd "$repo_dir"
    
    # Initialize with specified branch
    git init -b "$DEFAULT_BRANCH"
    
    # Create initial files
    echo -e "${YELLOW}📝 Creating initial files...${NC}"
    
    # Create README
    cat > README.md << EOF
# ${new_repo_name}

## Description
Add your project description here.

## Installation
\`\`\`bash
# Add installation instructions
\`\`\`

## Usage
\`\`\`bash
# Add usage examples
\`\`\`

## Contributing
Pull requests are welcome. For major changes, please open an issue first.

## License
[MIT](https://choosealicense.com/licenses/mit/)
EOF

    # Create comprehensive .gitignore
    cat > .gitignore << 'EOF'
# Dependencies
node_modules/
vendor/
venv/
env/
.env.local
.env.*.local

# Build outputs
dist/
build/
out/
target/
*.egg-info/
__pycache__/
*.pyc

# IDE
.vscode/*
!.vscode/tasks.json
!.vscode/launch.json
!.vscode/extensions.json
.idea/
*.swp
*.swo
*~

# OS
.DS_Store
Thumbs.db

# Logs
*.log
logs/
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# Environment
.env
.env.*
!.env.example

# Testing
coverage/
.coverage
.pytest_cache/
.phpunit.result.cache

# Misc
*.bak
*.tmp
.cache/
EOF

    # Create .editorconfig
    cat > .editorconfig << 'EOF'
root = true

[*]
indent_style = space
indent_size = 2
end_of_line = lf
charset = utf-8
trim_trailing_whitespace = true
insert_final_newline = true

[*.{py,php}]
indent_size = 4

[*.{md,markdown}]
trim_trailing_whitespace = false

[Makefile]
indent_style = tab
EOF

    git add .
    git commit -m "Initial commit"
    
    echo -e "${YELLOW}🔧 Setting up remotes...${NC}"
    git remote add origin "ssh://git@git.superpowerlabs.app:2222/${REAL_USER}/${new_repo_name}.git"
    git remote add alt "ssh://git@pool:2222/${REAL_USER}/${new_repo_name}.git"
    
    echo -e "${YELLOW}📡 Remote configuration:${NC}"
    git remote -v
    
    echo -e "${YELLOW}📤 Creating and pushing to repositories...${NC}"
    echo -e "${BLUE}Note: Attempting to create repositories on git servers${NC}"
    
    # Push to remotes
    if git push -u origin "$DEFAULT_BRANCH" 2>/dev/null; then
        echo -e "${GREEN}✓ Repository created and pushed to origin${NC}"
    else
        echo -e "${RED}⚠️  Failed to push to origin. You may need to create it manually:${NC}"
        echo -e "${YELLOW}   ssh://git@git.superpowerlabs.app:2222/${REAL_USER}/${new_repo_name}.git${NC}"
    fi
    
    if git push -u alt "$DEFAULT_BRANCH" 2>/dev/null; then
        echo -e "${GREEN}✓ Repository created and pushed to alt${NC}"
    else
        echo -e "${RED}⚠️  Failed to push to alt. You may need to create it manually:${NC}"
        echo -e "${YELLOW}   ssh://git@pool:2222/${REAL_USER}/${new_repo_name}.git${NC}"
    fi
    
    # Create sync script and VS Code settings
    create_sync_script "$repo_dir" "$new_repo_name" "false" "$DEFAULT_BRANCH"
    create_vscode_settings "$repo_dir"
fi

# Create a project-specific README for the scripts
cat > "${repo_dir}/scripts/README.md" << 'EOF'
# Git Scripts

This directory contains helpful git automation scripts:

## git-sync.sh
Main synchronization script that:
- Checks for uncommitted changes
- Syncs with upstream (for forks)
- Pushes to all configured remotes
- Shows repository status

Usage: `./scripts/git-sync.sh`

## quick-sync.sh
Quick commit and sync that:
- Adds all changes
- Commits with timestamp
- Runs full sync

Usage: `./scripts/quick-sync.sh`

## VS Code Integration
Use `Ctrl+Shift+B` to run git-sync from VS Code.
See `.vscode/keybindings.json` for keyboard shortcut suggestions.
EOF

# Final output
echo
echo -e "${GREEN}✅ Repository setup complete!${NC}"
echo
echo -e "${BLUE}📁 Repository location: ${repo_dir}${NC}"
echo -e "${BLUE}🔄 Sync script: ${repo_dir}/scripts/git-sync.sh${NC}"
echo -e "${BLUE}⚡ Quick sync: ${repo_dir}/scripts/quick-sync.sh${NC}"
echo
echo -e "${YELLOW}📝 Next steps:${NC}"
echo -e "  1. cd ${repo_dir}"
echo -e "  2. Start working on your project!"
echo -e "  3. Run ${PURPLE}./scripts/git-sync.sh${NC} to sync with remotes"
echo -e "  4. Or use ${PURPLE}Ctrl+Shift+B${NC} in VS Code"

if [[ $fork_choice =~ ^[Yy] ]]; then
    echo -e "  5. Periodically sync to get upstream updates"
fi

echo
echo -e "${GREEN}Happy coding! 🚀${NC}"

# Launch VS Code if available
if command_exists code; then
    echo
    echo -e "${YELLOW}🚀 Launching VS Code...${NC}"
    code "$repo_dir"
    echo -e "${GREEN}✓ VS Code launched${NC}"
    
    # Show VS Code tips
    echo
    echo -e "${PURPLE}💡 VS Code Tips:${NC}"
    echo -e "  • ${BLUE}Ctrl+Shift+B${NC} → Run Git Sync"
    echo -e "  • Check ${BLUE}.vscode/keybindings.json${NC} for shortcuts"
    echo -e "  • Terminal: ${BLUE}./scripts/git-sync.sh${NC}"
else
    echo
    echo -e "${YELLOW}💡 Tip: Install VS Code for automatic project opening${NC}"
fi

# Create convenience alias
echo "alias cdrepo='cd ${repo_dir}'" >> "${USER_HOME}/.bash_aliases"
echo
echo -e "${BLUE}📍 Added alias: ${PURPLE}cdrepo${NC} → cd to ${repo_dir}${NC}"
echo -e "${BLUE}   (Reload shell or run: ${PURPLE}source ~/.bash_aliases${NC})${NC}"
