# Claude Code Help Documentation - Fully Annotated

## Overview
```
Usage: claude [options] [command] [prompt]
```
**What this means:** Claude Code starts an **interactive session by default** (like a conversation). You don't need a special "ide" command - it's already interactive! Use `-p/--print` if you want non-interactive output (one response then exit).

## Arguments
```
prompt                           Your prompt
```
**What this means:** You can provide an initial prompt/question directly. This is optional - if you don't provide one, Claude will wait for your first message.

## Options

### Debug & Verbose Options
```
-d, --debug                      Enable debug mode
--verbose                        Override verbose mode setting from config
--mcp-debug                      [DEPRECATED. Use --debug instead] Enable MCP debug mode
```
**What these do:**
- `--debug`: Shows detailed debugging information about what Claude is doing
- `--verbose`: Shows extra output during execution (can be set in config file too)
- `--mcp-debug`: OLD FLAG - use `--debug` instead. MCP = Model Context Protocol

### Output Control Options
```
-p, --print                      Print response and exit (useful for pipes)
--output-format <format>         Output format (only works with --print): 
                                "text" (default), "json", or "stream-json"
--input-format <format>          Input format (only works with --print): 
                                "text" (default), or "stream-json"
```
**What these do:**
- `--print`: Makes Claude give ONE response then exit (non-interactive). Perfect for scripts!
- `--output-format`: Control how the response is formatted (text/JSON)
- `--input-format`: Control how Claude reads input (for piping data in)

### Permission & Safety Options
```
--dangerously-skip-permissions   Bypass all permission checks. 
                                Recommended only for sandboxes with no internet access.
--permission-mode <mode>         Permission mode to use for the session 
                                (choices: "acceptEdits", "bypassPermissions", "default", "plan")
```
**What these do:**
- `--dangerously-skip-permissions`: DANGER! Skips all "are you sure?" prompts. Claude can modify files without asking!
- `--permission-mode`: Fine-tune how permissions work:
  - `acceptEdits`: Auto-accept file edits
  - `bypassPermissions`: Skip all permission checks
  - `default`: Normal behavior (asks for permission)
  - `plan`: Planning mode (doesn't execute, just plans)

### Tool Control Options
```
--allowedTools <tools...>        Comma or space-separated list of tool names to allow 
                                (e.g. "Bash(git:*) Edit")
--disallowedTools <tools...>     Comma or space-separated list of tool names to deny 
                                (e.g. "Bash(git:*) Edit")
--add-dir <directories...>       Additional directories to allow tool access to
```
**What these do:**
- `--allowedTools`: Whitelist specific tools Claude can use. Use "all" for everything
- `--disallowedTools`: Blacklist specific tools Claude cannot use
- `--add-dir`: Give Claude access to additional directories beyond current

**Tool Examples:**
- `Bash`: Terminal commands
- `Edit`: File editing
- `Bash(git:*)`: Git commands specifically
- Pattern: `ToolName(specific:command)`

### MCP Configuration
```
--mcp-config <file or string>    Load MCP servers from a JSON file or string
--strict-mcp-config              Only use MCP servers from --mcp-config, 
                                ignoring all other MCP configurations
```
**What this does:** MCP (Model Context Protocol) servers extend Claude's capabilities. You can load custom server configurations from a JSON file.

### System Prompt Customization
```
--append-system-prompt <prompt>  Append a system prompt to the default system prompt
```
**What this does:** Add extra instructions to Claude's base behavior. Like giving Claude a permanent instruction that applies to the whole session.

### Session Management
```
-c, --continue                   Continue the most recent conversation
-r, --resume [sessionId]         Resume a conversation - provide a session ID or 
                                interactively select a conversation to resume
--session-id <uuid>              Use a specific session ID for the conversation 
                                (must be a valid UUID)
```
**What these do:**
- `--continue`: Pick up where you left off in your last chat
- `--resume`: Resume a specific older conversation (by ID or interactive selection)
- `--session-id`: Start a new session with a specific ID you choose

### Model Selection
```
--model <model>                  Model for the current session. 
                                Aliases: 'sonnet' or 'opus'
                                Full names: 'claude-sonnet-4-20250514'
--fallback-model <model>         Enable automatic fallback to specified model 
                                when default model is overloaded (only works with --print)
```
**What these do:**
- `--model`: Choose which Claude model to use (Opus 4.1 is most powerful)
- `--fallback-model`: Backup model if primary is busy (only for non-interactive mode)

### IDE Integration
```
--ide                            Automatically connect to IDE on startup 
                                if exactly one valid IDE is available
```
**What this does:** Auto-connects to your code editor (VS Code, etc.) if Claude detects one running.

### Configuration & Settings
```
--settings <file-or-json>        Path to a settings JSON file or a JSON string 
                                to load additional settings from
```
**What this does:** Load custom settings from a file or JSON string for this session.

### Version & Help
```
-v, --version                    Output the version number
-h, --help                       Display help for command
```

## Commands (Subcommands)

```
config                           Manage configuration 
                                (eg. claude config set -g theme dark)
```
**What this does:** Manage Claude's persistent settings globally or per-project.

```
mcp                              Configure and manage MCP servers
```
**What this does:** Set up Model Context Protocol servers to extend Claude's capabilities.

```
migrate-installer                Migrate from global npm installation to local installation
```
**What this does:** Move from old npm-based install to new local installer.

```
setup-token                      Set up a long-lived authentication token 
                                (requires Claude subscription)
```
**What this does:** Configure authentication so you don't have to log in repeatedly.

```
doctor                           Check the health of your Claude Code auto-updater
```
**What this does:** Diagnose problems with Claude Code installation/updates.

```
update                           Check for updates and install if available
```
**What this does:** Manually check for and install Claude Code updates.

```
install [options] [target]       Install Claude Code native build. 
                                Use [target] to specify version 
                                (stable, latest, or specific version)
```
**What this does:** Install or reinstall Claude Code, optionally specifying which version.

---

## Common Usage Patterns

### Interactive Session (Default)
```bash
claude                          # Start interactive session
claude "Help me with Python"    # Start with initial prompt
```

### One-Shot Commands (Non-Interactive)
```bash
claude --print "Write a Python hello world"           # Get response and exit
claude --print "Fix this bug" < buggy_code.py        # Pipe in a file
```

### With Custom Permissions
```bash
claude --dangerously-skip-permissions    # Live dangerously (no confirmations)
claude --permission-mode plan            # Just plan, don't execute
```

### With Specific Tools
```bash
claude --allowedTools "Edit"             # Only allow file editing
claude --allowedTools "all"              # Allow everything
claude --disallowedTools "Bash"          # Prevent terminal commands
```

### Resume Previous Work
```bash
claude --continue                        # Continue last conversation
claude --resume                          # Pick from list of past conversations
```