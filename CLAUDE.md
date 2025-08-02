# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

Git-Go is a professional Git repository initialization and management tool that automates repository creation with intelligent sync scripts, VS Code integration, and AI-assisted development support.

## Project Structure

```
git-go/
├── bin/
│   └── git-go           # Main executable
├── lib/
│   ├── colors.sh        # Color output functions
│   └── git-utils.sh     # Git utility functions
├── config/
│   └── git-go.conf.example  # Configuration template
├── tests/
│   └── test.sh          # Test suite
└── deploy.sh            # Local deployment script
```

## Key Commands

### Development
- `./deploy.sh` - Deploy git-go to ~/bin/ for local testing
- `./tests/test.sh` - Run the test suite
- `./bin/git-go help` - Test the main script directly

### Usage (after deployment)
- `git-go new --name <name>` - Create new repository
- `git-go fork --url <url>` - Fork existing repository
- `git-go config` - Edit configuration
- `git-go help` - Show help

## Architecture

### Main Script (bin/git-go)
- Modular design with separate command functions
- Configuration loaded from ~/.config/git-go/config
- Supports both interactive and CLI argument modes
- Generates repository-specific sync scripts

### Generated Sync Scripts
Each created repository gets:
- `scripts/sync.sh` - Intelligent sync with stash handling, upstream tracking (for forks), and multi-remote push
- `.vscode/tasks.json` - VS Code build task for Ctrl+Shift+B sync
- `CLAUDE.md` - AI assistant instructions

### Configuration System
- User config at ~/.config/git-go/config
- Supports dual git servers (primary and secondary)
- Customizable templates and features
- Environment variable overrides supported

## Testing

Run tests with: `./tests/test.sh`

Tests cover:
- Command functionality (help, version, new, fork)
- File generation
- Name validation
- Duplicate prevention

## Code Style

- Bash 4.0+ features used
- Functions use snake_case
- Variables are always quoted
- Error handling with colored output
- Modular design with sourced libraries