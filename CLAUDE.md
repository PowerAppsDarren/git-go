# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

git-go is a Git repository initialization and management system that automates the setup of new repositories and forks with intelligent sync scripts, VS Code integration, and AI-assisted development support.

## Key Commands

### Deployment and Usage
- `./deploy.sh` - Deploy the launcher script to ~/git-go.sh for system-wide access
- `~/git-go.sh` - Run the main script from anywhere after deployment
- `./git-go.sh` - Run the main script directly from the repository

### Repository Management  
The main script creates repositories with:
- Automated git-sync.sh and quick-sync.sh scripts in the scripts/ directory
- VS Code tasks.json for Ctrl+Shift+B sync integration
- claude.md file for AI-assisted development instructions

## Architecture Overview

### Core Components

1. **git-go.sh** - Main interactive script that:
   - Handles both forking existing repos and creating new ones
   - Sets up dual remotes (origin and alt) pointing to git.superpowerlabs.app and pool servers
   - Creates intelligent sync scripts tailored to repository type (fork vs original)
   - Generates claude.md files for AI assistance
   - Configures VS Code integration

2. **deploy.sh** - Deployment script that:
   - Creates a lightweight launcher at ~/git-go.sh
   - Ensures the launcher always executes the latest version from ~/src/git-go/

3. **Generated Scripts** (created in each new repository):
   - `scripts/git-sync.sh` - Comprehensive sync with stash handling, retry logic, and upstream sync for forks
   - `scripts/quick-sync.sh` - Quick commit with timestamp and automatic sync
   - `.vscode/tasks.json` - VS Code build task integration

### Key Design Decisions

- **Dual Remote Setup**: All repos get both origin and alt remotes for redundancy
- **Fork-Aware Sync**: Forked repos get special handling with upstream remote and merge prompts
- **Stash Management**: Sync scripts handle uncommitted changes gracefully with interactive stashing
- **Retry Logic**: Network operations retry up to 3 times with exponential backoff
- **Branch Detection**: Automatically detects and uses the default branch (main/master)

### Remote Configuration

- Origin: `ssh://git@git.superpowerlabs.app:2222/${USER}/${REPO}.git`
- Alt: `ssh://git@pool:2222/${USER}/${REPO}.git`
- Upstream (forks only): Original repository URL

## Script Evolution

The scripts/ directory contains earlier versions showing the evolution of features:
- setup-git-repo.sh - Original basic version
- enhanced-git-go.sh - Added status displays and better error handling  
- setup-git-repo-v2.sh - Added tool checks and VS Code integration
- git-go.sh (main) - Current version with claude.md creation and all enhancements