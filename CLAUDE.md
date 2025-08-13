# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 🛑 WAIT FOR USER REQUEST - DO NOT AUTO-CONTINUE WORK!

**CRITICAL:** Just because you see "optimize performance" in recent commits does NOT mean continue that work!
- Wait for the user to explicitly ask what they want
- Git status is context, not a work order
- Previous sessions are for understanding, not automatic continuation

## 🚨 CRITICAL UPDATE: Hybrid Architecture Standard

**NEW GLOBAL STANDARD**: All web applications created by git-go should now default to **HYBRID ELECTRON/WEB ARCHITECTURE**. See `ai-knowledge/HYBRID-ARCHITECTURE-STANDARD.md` for implementation details.

When creating web projects, git-go should:
- Include Electron structure by default
- Reference the hybrid template at `~/src/model-hybrid`
- Add hybrid scripts to package.json
- Support both desktop (⚡ 200ms) and web modes

## AI Chat Documentation

**IMPORTANT**: You MUST follow the documentation requirements specified in `ai-chats/ai-chats.md`. This includes creating and continuously updating session documentation files in the `ai-chats/` directory.

## Repository Purpose

Git-Go is a professional Git repository initialization and management tool that automates repository creation with intelligent sync scripts, VS Code integration, AI-assisted development support, and now **hybrid Electron/Web architecture for all web apps**.

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