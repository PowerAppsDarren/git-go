#!/bin/bash
# Performance optimization utilities for git-go

# Cache for command existence checks
declare -A COMMAND_CACHE

# Cache for git remote info
declare -A REMOTE_CACHE

# Check if command exists with caching
cached_command_exists() {
    local cmd=$1
    
    # Check cache first
    if [[ -n "${COMMAND_CACHE[$cmd]}" ]]; then
        return "${COMMAND_CACHE[$cmd]}"
    fi
    
    # Check command and cache result
    if command -v "$cmd" &>/dev/null; then
        COMMAND_CACHE[$cmd]=0
        return 0
    else
        COMMAND_CACHE[$cmd]=1
        return 1
    fi
}

# Batch file creation to reduce I/O operations
create_files_batch() {
    local repo_dir=$1
    shift
    local files=("$@")
    
    # Create all directories first
    local dirs=()
    for file in "${files[@]}"; do
        local dir=$(dirname "$file")
        if [[ "$dir" != "." && "$dir" != "$repo_dir" ]]; then
            dirs+=("$repo_dir/$dir")
        fi
    done
    
    # Create unique directories in one go
    if [[ ${#dirs[@]} -gt 0 ]]; then
        printf '%s\n' "${dirs[@]}" | sort -u | xargs mkdir -p
    fi
}

# Parallel git fetch for multiple remotes
parallel_fetch_remotes() {
    local remotes=("$@")
    local pids=()
    
    # Start parallel fetches
    for remote in "${remotes[@]}"; do
        git fetch "$remote" --quiet 2>/dev/null &
        pids+=($!)
    done
    
    # Wait for all fetches to complete
    local failed=()
    for i in "${!pids[@]}"; do
        if ! wait "${pids[$i]}"; then
            failed+=("${remotes[$i]}")
        fi
    done
    
    # Return failed remotes
    if [[ ${#failed[@]} -gt 0 ]]; then
        printf '%s\n' "${failed[@]}"
        return 1
    fi
    return 0
}

# Fast directory size check
is_large_directory() {
    local dir=$1
    local threshold=${2:-1000}  # Default 1000 files
    
    # Use find with -quit to stop after threshold
    local count=$(find "$dir" -type f -print -quit | head -n "$threshold" | wc -l)
    [[ $count -ge $threshold ]]
}

# Optimized git status check
has_uncommitted_changes() {
    # Use git diff-index for faster check
    ! git diff-index --quiet HEAD -- 2>/dev/null
}

# Get git info in single command
get_git_info() {
    git rev-parse --abbrev-ref HEAD --show-toplevel --git-dir 2>/dev/null
}

# Cached git remote check
cached_remote_exists() {
    local remote=$1
    local cache_key="remote_$remote"
    
    # Check cache first
    if [[ -n "${REMOTE_CACHE[$cache_key]}" ]]; then
        return "${REMOTE_CACHE[$cache_key]}"
    fi
    
    # Check remote and cache result
    if git remote | grep -q "^$remote$"; then
        REMOTE_CACHE[$cache_key]=0
        return 0
    else
        REMOTE_CACHE[$cache_key]=1
        return 1
    fi
}

# Batch git operations
batch_git_add() {
    local files=("$@")
    if [[ ${#files[@]} -gt 0 ]]; then
        git add "${files[@]}"
    fi
}

# Optimized file copy with progress for large operations
optimized_copy() {
    local src=$1
    local dst=$2
    local file_count=$(find "$src" -type f 2>/dev/null | wc -l)
    
    if [[ $file_count -gt 100 ]]; then
        # Use tar for large file counts (faster than cp -r)
        tar -cf - -C "$(dirname "$src")" "$(basename "$src")" | tar -xf - -C "$dst"
    else
        cp -r "$src" "$dst"
    fi
}