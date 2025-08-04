# GoGo Global Command

## Overview
GoGo has been made into a global command that can be run in any project directory to execute a comprehensive deployment and testing pipeline.

## Key Points
- Works with any project type (auto-detection)
- No configuration required
- Adapts to project-specific conventions
- Available globally via `~/bin/gogo`
- Part of Claude Global Features system

## Implementation Details

### Project Type Detection
The global gogo detects project types by looking for specific files:
- `package.json` → Node.js project
- `requirements.txt`, `setup.py`, `pyproject.toml` → Python project
- `go.mod` → Go project
- `Cargo.toml` → Rust project
- `pom.xml` → Java Maven project
- `build.gradle` → Java Gradle project
- `Gemfile` → Ruby project
- `composer.json` → PHP project
- `Makefile` → Make-based project
- `.git` → Generic git project
- Default → Generic project

### Pipeline Steps
1. **Test Execution**
   - Runs project-appropriate test commands
   - npm test, pytest, go test, cargo test, etc.
   - Falls back to test.sh or tests/test.sh

2. **Code Quality Checks**
   - Formatting (black, go fmt, cargo fmt, etc.)
   - Linting (flake8, npm run lint, etc.)

3. **Documentation Updates**
   - Adds timestamps to roadmap.md
   - Updates CHANGELOG.md with deployment entry

4. **Deployment**
   - Runs deploy.sh or scripts/deploy.sh
   - Executes make deploy if available
   - Runs npm run build for Node.js projects

5. **Repository Status**
   - Shows git status
   - Lists recent commits

6. **Summary Report**
   - Success/failure count
   - Timing information

## Examples

### Running in a Node.js Project
```bash
cd ~/projects/my-node-app
gogo

# Output:
# 🚀 GoGo - Universal Project Pipeline
# Project: my-node-app
# Detected project type: node
# Running npm test...
# Running npm run lint...
# Running npm run build...
```

### Running in a Python Project
```bash
cd ~/projects/my-python-app
gogo

# Output:
# 🚀 GoGo - Universal Project Pipeline
# Project: my-python-app
# Detected project type: python
# Running pytest...
# Running black formatting...
# Running flake8...
```

### Running in Git-Go Project
```bash
cd ~/src/git-go
gogo

# Output:
# 🚀 GoGo - Universal Project Pipeline
# Project: git-go
# Detected project type: generic-git
# Running ./tests/test.sh...
# Running ./deploy.sh...
```

## Installation
The global gogo has been installed to:
- `~/.claude/global-features/gogo/` - Source location
- `~/bin/gogo` - Executable in PATH

## Customization
Projects can customize gogo behavior by providing:
- Standard test commands in package.json, Makefile, etc.
- `test.sh` or `tests/test.sh` scripts
- `deploy.sh` or `scripts/deploy.sh` scripts
- `roadmap.md` or `ROADMAP.md` files
- `CHANGELOG.md` or `changelog.md` files

## Differences from Project-Specific gogo
- **Global gogo**: Generic, works with any project type
- **git-go gogo**: Specific to git-go project, updates git-go roadmap

Both versions share the same core concept but the global version is more flexible.

---
*Last Updated: 2025-08-04*