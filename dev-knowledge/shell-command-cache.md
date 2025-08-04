# Shell Command Cache and "Command Not Found" Issues

## Overview

When you install a new command or create a new executable during a shell session, you might encounter "command not found" errors even though the command exists and is in your PATH. This document explains why this happens and how to fix it.

## Why This Happens

### Command Hashing

Shells like Bash optimize command lookups by caching executable locations in a hash table:

1. When you first run a command, the shell searches through all directories in PATH
2. Once found, the shell remembers (caches) the location
3. Future calls use the cached location instead of searching again
4. This makes command execution faster

### The Problem

When you:
- Install a new program
- Create a new script or symlink
- Move an executable to a different location
- Add a new directory to PATH

The shell's cache doesn't automatically update. It still has the old information (or no information) about where commands are located.

## Solutions

### Quick Fixes

1. **Clear the entire cache:**
   ```bash
   hash -r
   ```

2. **Remove a specific command from cache:**
   ```bash
   hash -d command-name
   ```

3. **Use the full path once** (this updates the cache):
   ```bash
   /home/user/bin/mycommand
   # Now 'mycommand' will work
   ```

4. **Start a new terminal session** (gets a fresh cache)

### Checking the Cache

View all cached commands:
```bash
hash
```

Check if a specific command is cached:
```bash
type command-name
```

## Why This Happens Often During Development

This issue is particularly common when:

1. **Working with AI assistants** - We often create/modify executables within the same shell session
2. **Installing development tools** - npm, pip, cargo, etc. install executables during the session
3. **Creating custom scripts** - Adding new scripts to ~/bin or other PATH directories
4. **Testing installations** - Running deploy scripts that create new commands

## Best Practices

1. **After installing new commands**, run:
   ```bash
   hash -r
   ```

2. **In installation scripts**, you can add:
   ```bash
   echo "Run 'hash -r' or start a new terminal to use the new commands"
   ```

3. **For critical scripts**, use full paths or check command availability:
   ```bash
   if ! command -v mycommand &> /dev/null; then
       echo "mycommand not found, trying to refresh cache..."
       hash -r
   fi
   ```

## Shell Differences

- **Bash**: Uses hash table, requires manual refresh
- **Zsh**: Can be configured to auto-refresh with `setopt rehash`
- **Fish**: Automatically updates command cache
- **Dash/sh**: Minimal caching, less prone to this issue

## Example Scenario

```bash
# Create a new script
echo '#!/bin/bash\necho "Hello"' > ~/bin/hello
chmod +x ~/bin/hello

# Try to run it
hello  # Error: command not found

# Fix it
hash -r
hello  # Works: Hello
```

## Related Issues

- **PATH changes**: Similar caching happens with PATH modifications
- **Aliases**: Different mechanism but similar "not found" symptoms
- **Functions**: Shell functions take precedence over external commands

## Summary

The "command not found" error after installation isn't a bug—it's the shell being efficient. Understanding command caching helps you:
- Diagnose why newly installed commands aren't found
- Know when to refresh the cache
- Write better installation scripts
- Avoid frustration during development

Remember: When in doubt, `hash -r` or open a new terminal!