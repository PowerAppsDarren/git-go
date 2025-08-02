#!/bin/bash
# Git-related utility functions

# Extract repository info from URL
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
    elif [[ $url =~ ([^/:]+)[:/]([^/]+)/([^/]+)$ ]]; then
        author="${BASH_REMATCH[2]}"
        repo="${BASH_REMATCH[3]}"
    fi
    
    echo "$author|$repo"
}

# Check if we're in a git repository
is_git_repo() {
    git rev-parse --is-inside-work-tree &>/dev/null
}

# Get current branch name
get_current_branch() {
    git rev-parse --abbrev-ref HEAD 2>/dev/null
}

# Get default branch of a remote
get_default_branch() {
    local remote=${1:-origin}
    git symbolic-ref "refs/remotes/$remote/HEAD" 2>/dev/null | sed "s@^refs/remotes/$remote/@@"
}

# Check if command exists
command_exists() {
    command -v "$1" &>/dev/null
}

# Validate repository name
validate_repo_name() {
    local name=$1
    if [[ ! "$name" =~ ^[a-zA-Z0-9][a-zA-Z0-9._-]*$ ]]; then
        return 1
    fi
    return 0
}

# Setup git remote
setup_remote() {
    local name=$1
    local url=$2
    
    if git remote | grep -q "^$name$"; then
        git remote set-url "$name" "$url"
    else
        git remote add "$name" "$url"
    fi
}