# AI Chat Documentation Requirements

## MANDATORY: Document Every Session

When working on this project, you MUST create and maintain documentation in the `ai-chats/` directory. This is NOT optional.

## File Naming Convention
Create files following: `YYYY-MM-DD-XX-PHRASE.md`
- **YYYY-MM-DD**: Today's date
- **XX**: Sequential session number (01, 02, 03...)
- **PHRASE**: 1-3 word topic description

### Examples:
- `2025-07-22-01-database-integration.md` - First session on July 22nd about database
- `2025-07-26-01-linux-agent-creation.md` - First session on July 26th about Linux agent
- `2025-08-03-01-electron-ui-hdpi.md` - First session on Aug 3rd about UI improvements

## Required Documentation Structure
Each session file MUST include:

### 1. Session Header
```markdown
# AI Chat Session: YYYY-MM-DD-XX - Topic

## Session Overview
**Date**: Month DD, YYYY
**Topic**: Brief description
**Claude Instance**: Claude Code (model version)
```

### 2. Conversation Summary
- Initial user request
- Main tasks completed
- Key decisions made
- Problems encountered and solutions

### 3. Technical Details
- Code changes made
- Files created/modified
- Commands executed
- Architecture decisions

### 4. Complete Exchanges
- Actual prompts from user
- AI responses and reasoning
- Any clarifications or iterations

### 5. Lessons Learned
- What worked well
- What could be improved
- Important discoveries

### 6. Next Steps
- Unfinished tasks
- Recommended follow-ups
- Open questions

## Update Protocol
1. **Create new file** at session start
2. **Update continuously** - after EVERY exchange
3. **Include everything** - prompts, responses, code, decisions
4. **Commit frequently** - never leave documentation uncommitted

## Why This Matters
AI assistants have no persistent memory between sessions. Without documentation:
- Previous decisions and context are lost
- Work may be duplicated or contradicted
- Technical rationale disappears
- Project evolution becomes unclear

This documentation creates "artificial memory" allowing future sessions to:
- Understand full project history
- Continue where previous work left off
- Avoid repeating mistakes
- Maintain consistency

## Reading Past Sessions
When starting work on this project:
1. Check the most recent session files
2. Look for relevant past sessions by topic
3. Understand the project's evolution
4. Continue from where others left off

## Important Notes
- **This is NOT optional** - Session documentation is MANDATORY
- **Update in real-time** - Don't wait until session end
- **Be thorough** - Future AI instances depend on this information
- **Include failures** - Document what didn't work and why

Remember: You're creating a knowledge base for all future AI assistants. Your documentation is their memory.