# Global Keywords

## Overview
Global keywords are special trigger words that Claude Code recognizes across all repositories and contexts. These provide consistent, powerful automation commands that work anywhere without needing project-specific configuration.

## Key Points
- Keywords work in ANY repository or directory
- No setup or configuration required
- Consistent behavior across all projects
- Defined in `~/.claude/CLAUDE.md` or project CLAUDE.md files
- Case-sensitive triggers

## Implementation Details

### Current Global Keywords

1. **`wrapup`** - Session wrap-up with git commit
   - Stages all changes (`git add -A`)
   - Creates commit with format: "Session wrap-up: [description]"
   - Does NOT push unless explicitly requested
   - Updates AI chat documentation

2. **`docthat`** - Create/update documentation
   - Creates `dev-knowledge/` directory if needed
   - Uses kebab-case filenames
   - Follows standard documentation template
   - Includes metadata (last updated date)

3. **`makeitglobal`** - Make feature globally available
   - Copies feature to `~/.claude/global-features/`
   - Updates global registry
   - Makes feature available in all projects

4. **`triggers`** - List all available triggers
   - Shows global triggers (🌍)
   - Shows project-specific triggers (📁)
   - Displays total count

## Examples

### Using `wrapup`
```bash
# User types:
wrapup implemented new template copying feature

# Claude executes:
git add -A
git commit -m "Session wrap-up: implemented new template copying feature"
git log -1 --oneline
# Updates ai-chats documentation
```

### Using `docthat`
```bash
# User types:
docthat api-patterns

# Claude creates/updates:
dev-knowledge/api-patterns.md
# With proper structure and content
```

### Using `makeitglobal`
```bash
# User types:
makeitglobal gogo-command

# Claude:
mkdir -p ~/.claude/global-features/gogo-command
cp gogo ~/.claude/global-features/gogo-command/
# Updates registry.md
```

### Using `triggers`
```bash
# User types:
triggers

# Claude displays:
🌍 GLOBAL TRIGGERS:
- wrapup: Create git commit with session summary
- docthat: Create documentation in dev-knowledge
- makeitglobal: Make feature available globally
- triggers: List all active triggers

📁 PROJECT TRIGGERS:
- gogo: Run comprehensive deployment pipeline

Total: 5 triggers available
```

## Configuration

Global keywords are defined in:
1. `~/.claude/CLAUDE.md` - User-wide global keywords
2. `~/CLAUDE.md` - Home directory configuration
3. `[project]/CLAUDE.md` - Project-specific keywords

Priority order: Project > Home > Global

## Best Practices

1. **Naming Conventions**
   - Use lowercase, single words when possible
   - Avoid common programming terms
   - Make them memorable and intuitive

2. **Documentation**
   - Always document new keywords in CLAUDE.md
   - Include examples in the documentation
   - Update `triggers` output

3. **Error Handling**
   - Keywords should handle edge cases gracefully
   - Provide clear feedback on success/failure
   - Don't perform destructive actions without confirmation

4. **Consistency**
   - Maintain consistent behavior across projects
   - Use similar patterns for similar actions
   - Follow established conventions

---
*Last Updated: 2025-08-04*