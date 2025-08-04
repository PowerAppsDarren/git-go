# AI Chat Documentation Directory

## Repository Template Usage

This directory is part of a repository template that implements AI memory/documentation best practices. When using this template:

1. **Keep this directory** - The `ai-chats/` folder should remain in all projects based on this template
2. **Apply to CLAUDE.md** - The documentation requirements from `ai-chats.md` should be referenced in your project's `CLAUDE.md` file
3. **Start documenting immediately** - Begin creating session files from your first AI interaction

## How It Works

1. **Template Setup**: When creating a new repository from this template:
   - Keep the `ai-chats/` directory structure
   - Keep the `ai-chats.md` file with documentation guidelines
   - Update your project's `CLAUDE.md` to reference `ai-chats.md`

2. **AI Sessions**: Every AI assistant working on the project:
   - Reads the documentation requirements from `ai-chats.md`
   - Creates session files in this directory following the naming convention
   - Updates documentation continuously throughout the session

3. **Knowledge Persistence**: Future AI sessions:
   - Review past session files to understand project history
   - Continue from where previous sessions left off
   - Maintain consistency across different AI instances

## Directory Contents

- **Session Files**: `YYYY-MM-DD-XX-PHRASE.md` files documenting each AI session
- **This README**: Explains the template usage and purpose
- **Referenced by**: Your project's `CLAUDE.md` should point to `ai-chats.md` for full documentation requirements

## Example CLAUDE.md Reference

Your project's `CLAUDE.md` should include:

```markdown
## AI Chat Documentation

**IMPORTANT**: You MUST follow the documentation requirements specified in `ai-chats.md`. This includes creating and continuously updating session documentation files in the `ai-chats/` directory.
```

## Why This Matters

AI assistants have no persistent memory between sessions. This documentation system creates "artificial memory" that enables:
- Continuous project understanding across sessions
- Prevention of duplicate or contradictory work
- Preservation of technical decisions and rationale
- Clear project evolution tracking

---

Remember: This template ensures every AI-assisted project maintains proper documentation for knowledge continuity.