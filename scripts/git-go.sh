#!/bin/bash
#
# Interactive Git Repository Setup Script
# Handles both forking existing repos and creating new ones

    # Make the script executable
    #chmod +x git-go.sh

    # Now run it
    #./git-go.sh

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

# Use the user's src directory
SRC_DIR="${USER_HOME}/src"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to extract author and repo name from URL
extract_repo_info() {
    local url=$1
    local author=""
    local repo=""
    
    # Remove .git suffix if present
    url=${url%.git}
    
    # Handle different URL formats
    if [[ $url =~ github\.com[:/]([^/]+)/([^/]+)$ ]]; then
        # GitHub URLs (https or git@)
        author="${BASH_REMATCH[1]}"
        repo="${BASH_REMATCH[2]}"
    elif [[ $url =~ gitlab\.com[:/]([^/]+)/([^/]+)$ ]]; then
        # GitLab URLs
        author="${BASH_REMATCH[1]}"
        repo="${BASH_REMATCH[2]}"
    elif [[ $url =~ bitbucket\.org[:/]([^/]+)/([^/]+)$ ]]; then
        # Bitbucket URLs
        author="${BASH_REMATCH[1]}"
        repo="${BASH_REMATCH[2]}"
    elif [[ $url =~ git\.sr\.ht/~([^/]+)/([^/]+)$ ]]; then
        # Sourcehut URLs
        author="${BASH_REMATCH[1]}"
        repo="${BASH_REMATCH[2]}"
    elif [[ $url =~ ([^/:]+)[:/]([^/]+)/([^/]+)$ ]]; then
        # Generic git URL pattern
        author="${BASH_REMATCH[2]}"
        repo="${BASH_REMATCH[3]}"
    fi
    
    echo "$author|$repo"
}

# Function to create sync script
create_sync_script() {
    local repo_dir=$1
    local repo_name=$2
    local is_fork=$3
    local branch_name=$4
    
    mkdir -p "${repo_dir}/scripts"
    
    if [ "$is_fork" = "true" ]; then
        cat > "${repo_dir}/scripts/git-sync.sh" << EOF
#!/bin/bash
#
# Sync script for ${repo_name}
# Updates from upstream and pushes to all remotes
#

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "\${YELLOW}🔄 Syncing ${repo_name}...\${NC}"

# Check for uncommitted changes
if ! git diff-index --quiet HEAD --; then
    echo -e "\${RED}⚠️  You have uncommitted changes. Please commit or stash them first.\${NC}"
    exit 1
fi

# Detect current branch
current_branch=\$(git rev-parse --abbrev-ref HEAD)

# Ensure we're on the main branch
echo -e "\${YELLOW}🔀 Switching to \${current_branch} branch...\${NC}"
git checkout \${current_branch}

# Push any local commits first
echo -e "\${YELLOW}📤 Pushing local changes...\${NC}"
git push origin \${current_branch}
git push alt \${current_branch}

# Fetch and merge changes from upstream
echo -e "\${YELLOW}📥 Fetching upstream changes...\${NC}"
git fetch upstream

# Check if there are updates
if git rev-list HEAD...upstream/\${current_branch} --count | grep -q "^0\$"; then
    echo -e "\${GREEN}✅ Already up to date with upstream!\${NC}"
    exit 0
fi

# Show what's new
echo -e "\${YELLOW}📋 New commits from upstream:\${NC}"
git log HEAD..upstream/\${current_branch} --oneline

# Merge upstream changes
echo -e "\${YELLOW}🔄 Merging upstream changes...\${NC}"
git merge upstream/\${current_branch}

# Push the merged changes
echo -e "\${YELLOW}📤 Pushing merged changes...\${NC}"
git push origin \${current_branch}
git push alt \${current_branch}

echo -e "\${GREEN}✅ Sync complete!\${NC}"
EOF
    else
        cat > "${repo_dir}/scripts/git-sync.sh" << EOF
#!/bin/bash
#
# Sync script for ${repo_name}
# Pushes to all remotes
#

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "\${YELLOW}🔄 Syncing ${repo_name}...\${NC}"

# Check for uncommitted changes
if ! git diff-index --quiet HEAD --; then
    echo -e "\${RED}⚠️  You have uncommitted changes. Please commit or stash them first.\${NC}"
    exit 1
fi

# Detect current branch
current_branch=\$(git rev-parse --abbrev-ref HEAD)

# Push to all remotes
echo -e "\${YELLOW}📤 Pushing to all remotes...\${NC}"
git push origin \${current_branch}
git push alt \${current_branch}

echo -e "\${GREEN}✅ Sync complete!\${NC}"
EOF
    fi
    
    chmod +x "${repo_dir}/scripts/git-sync.sh"
}

# Main script starts here
# Remove clear command as it can cause issues in some terminals
echo
echo -e "${BLUE}====================================================================================${NC}"
echo -e "${BLUE}                    Interactive Git Repository Setup                               ${NC}"
echo -e "${BLUE}====================================================================================${NC}"
echo

# Show current context
echo -e "${YELLOW}Running as user: ${REAL_USER}${NC}"
echo -e "${YELLOW}Repository location: ${SRC_DIR}${NC}"
echo

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
    
    echo -e "${YELLOW}🔧 Setting up remotes...${NC}"
    git remote rename origin upstream
    git remote add origin "ssh://git@git.superpowerlabs.app:2222/${REAL_USER}/${new_repo_name}.git"
    git remote add alt "ssh://git@pool:2222/${REAL_USER}/${new_repo_name}.git"
    
    echo -e "${YELLOW}📡 Remote configuration:${NC}"
    git remote -v
    
    echo -e "${YELLOW}📤 Pushing to your repositories...${NC}"
    echo -e "${BLUE}Note: Make sure the remote repositories exist on your git server${NC}"
    
    # Detect the current branch name
    current_branch=$(git rev-parse --abbrev-ref HEAD)
    echo -e "${BLUE}Current branch: ${current_branch}${NC}"
    
    if ! git push -u origin "$current_branch" 2>/dev/null; then
        echo -e "${RED}⚠️  Failed to push to origin. Please create the repository on your git server first:${NC}"
        echo -e "${YELLOW}   ssh://git@git.superpowerlabs.app:2222/${REAL_USER}/${new_repo_name}.git${NC}"
    fi
    
    if ! git push -u alt "$current_branch" 2>/dev/null; then
        echo -e "${RED}⚠️  Failed to push to alt. Please create the repository on your git server first:${NC}"
        echo -e "${YELLOW}   ssh://git@pool:2222/${REAL_USER}/${new_repo_name}.git${NC}"
    fi
    
    # Create sync script
    create_sync_script "$repo_dir" "$new_repo_name" "true" "$current_branch"
    
else
    # New repository workflow
    echo
    echo -e "${YELLOW}Enter the name for your new repository:${NC}"
    read -p "> " new_repo_name
    
    if [ -z "$new_repo_name" ]; then
        echo -e "${RED}❌ Repository name cannot be empty!${NC}"
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
    
    # Initialize with main branch
    git init -b main
    
    # Create initial files
    echo -e "${YELLOW}📝 Creating initial files...${NC}"
    echo "# ${new_repo_name}" > README.md
    echo -e "node_modules/\n.env\n.DS_Store\n*.log" > .gitignore
    
    git add .
    git commit -m "Initial commit"
    
    echo -e "${YELLOW}🔧 Setting up remotes...${NC}"
    git remote add origin "ssh://git@git.superpowerlabs.app:2222/${REAL_USER}/${new_repo_name}.git"
    git remote add alt "ssh://git@pool:2222/${REAL_USER}/${new_repo_name}.git"
    
    echo -e "${YELLOW}📡 Remote configuration:${NC}"
    git remote -v
    
    echo -e "${YELLOW}📤 Pushing to your repositories...${NC}"
    
    # Detect the current branch name
    current_branch=$(git rev-parse --abbrev-ref HEAD)
    echo -e "${BLUE}Pushing branch: ${current_branch}${NC}"
    
    git push -u origin "$current_branch"
    git push -u alt "$current_branch"
    
    # Create sync script
    create_sync_script "$repo_dir" "$new_repo_name" "false" "$current_branch"
fi

# Final output
echo
echo -e "${GREEN}✅ Repository setup complete!${NC}"
echo
echo -e "${BLUE}📁 Repository location: ${repo_dir}${NC}"
echo -e "${BLUE}🔄 Sync script created: ${repo_dir}/scripts/git-sync.sh${NC}"
echo
echo -e "${YELLOW}Next steps:${NC}"
echo -e "  1. cd ${repo_dir}"
echo -e "  2. Start working on your project!"
echo -e "  3. Run ./scripts/git-sync.sh to sync with remotes"

if [[ $fork_choice =~ ^[Yy] ]]; then
    echo -e "  4. Periodically run ./scripts/git-sync.sh to get upstream updates"
fi

echo
echo -e "${GREEN}Happy coding! 🚀${NC}"

# Change to the repository directory
cd "${repo_dir}"

# Launch VS Code if available
if command -v code &> /dev/null; then
    echo
    echo -e "${YELLOW}🚀 Launching VS Code...${NC}"
    code .
    echo -e "${GREEN}✓ VS Code launched${NC}"
else
    echo
    echo -e "${YELLOW}💡 Tip: Install VS Code to automatically open your projects${NC}"
fi

# Note about the directory change
echo
echo -e "${BLUE}📍 Note: Run 'cd ${repo_dir}' to navigate to your new repository${NC}"
echo -e "${BLUE}   (The script has changed directories, but your shell needs to be updated)${NC}"

# Create a convenience script to change to the directory
echo "cd '${repo_dir}'" > "${USER_HOME}/.last-repo-dir"
echo -e "${YELLOW}💡 Tip: Run 'source ~/.last-repo-dir' to jump to your new repo${NC}"