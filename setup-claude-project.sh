#!/bin/bash
#
# Claude Code Project Setup Script v2.0
# Creates CLAUDE.md and supporting files for new projects
#
# Usage: ./setup-claude-project.sh [project_name] [project_description]
#
# Example:
#   ./setup-claude-project.sh MyApp "A web application for task management"
#   ./setup-claude-project.sh  # Interactive mode
#
# Version: 2.0.0
# Updated: January 2026
# Features: Subagents, Plan Mode, Cloud Deployment, MCP, Writing Profiles
#

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Claude Code Project Setup v2.0${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Get project name
if [ -n "$1" ]; then
    PROJECT_NAME="$1"
else
    echo -e "${YELLOW}Enter project name:${NC}"
    read -r PROJECT_NAME
fi

if [ -z "$PROJECT_NAME" ]; then
    echo -e "${RED}Error: Project name is required${NC}"
    exit 1
fi

# Get project description
if [ -n "$2" ]; then
    PROJECT_DESC="$2"
else
    echo -e "${YELLOW}Enter project description (one line):${NC}"
    read -r PROJECT_DESC
fi

if [ -z "$PROJECT_DESC" ]; then
    PROJECT_DESC="A Claude Code managed project"
fi

# Get current date
CURRENT_DATE=$(date +"%Y-%m-%d")

# Determine project directory
if [ -d "$PROJECT_NAME" ]; then
    PROJECT_DIR="$PROJECT_NAME"
    echo -e "${YELLOW}Directory '$PROJECT_NAME' exists. Setting up Claude Code files inside it.${NC}"
else
    echo -e "${YELLOW}Create new directory '$PROJECT_NAME'? (y/n):${NC}"
    read -r CREATE_DIR
    if [ "$CREATE_DIR" = "y" ] || [ "$CREATE_DIR" = "Y" ]; then
        mkdir -p "$PROJECT_NAME"
        PROJECT_DIR="$PROJECT_NAME"
        echo -e "${GREEN}Created directory: $PROJECT_NAME${NC}"
    else
        PROJECT_DIR="."
        echo -e "${YELLOW}Setting up in current directory${NC}"
    fi
fi

cd "$PROJECT_DIR"

echo ""
echo -e "${BLUE}Creating Claude Code project files...${NC}"
echo ""

# ============================================================================
# Create CLAUDE.md - Main Session Reference
# ============================================================================
cat > CLAUDE.md << 'CLAUDE_EOF'
# PROJECT_NAME_PLACEHOLDER - Claude Code Reference

**Auto-loaded by Claude Code at session start**

---

## Project Overview

PROJECT_DESC_PLACEHOLDER

---

## CRITICAL: Shell Script Line Endings

**BLOCKING REQUIREMENT**

The Write tool adds Windows-style CRLF line endings (`\r\n`) which break shell scripts on macOS/Linux.

**MANDATORY workflow for ALL .sh files:**

1. Write the shell script using Write tool
2. **IMMEDIATELY** fix line endings: `sed -i '' 's/\r$//' script.sh`
3. Make executable: `chmod +x script.sh`
4. Test: `./script.sh`

**This is NON-NEGOTIABLE. Skipping step 2 causes "bad interpreter" errors.**

---

## CRITICAL: Cloud-First Development

**This application should be designed to run in cloud environments.**

### Never Use Hardcoded Local Paths

**WRONG:**
```python
path = '/Users/username/projects/myapp'
```

**CORRECT:**
```python
import os
project_root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
path = os.environ.get('APP_ROOT', '/app')
```

### Before Writing Any Code, Ask:

1. Does this path exist in the cloud environment?
2. Are credentials loaded from environment variables?
3. Will this script be in the Docker image?
4. Am I using relative paths for portability?

---

## Subagent System

Claude Code uses specialized subagents for different tasks. Use the Task tool with the appropriate `subagent_type`.

### Available Subagents

| Type | Use For | Tools Available |
|------|---------|-----------------|
| `Explore` | Codebase exploration, finding files, understanding structure | Glob, Grep, Read |
| `Plan` | Designing implementation strategies, architecture decisions | All tools |
| `Bash` | Git operations, command execution, terminal tasks | Bash only |
| `general-purpose` | Complex multi-step tasks, research | All tools |

### When to Use Each

**Use `Explore` when:**
- "Where is X implemented?"
- "How does the authentication work?"
- "Find all files that handle payments"
- Quick codebase searches

**Use `Plan` when:**
- "How should I implement feature X?"
- "Design the database schema for..."
- Need architectural decisions before coding

**Use `Bash` when:**
- Git operations (commit, push, branch)
- Running build commands
- System administration tasks

**Use `general-purpose` when:**
- Complex research requiring multiple tools
- Tasks that don't fit other categories
- Multi-step investigations

### Model Selection

When spawning subagents, choose the model based on task complexity:

| Model | Use For | Cost |
|-------|---------|------|
| `haiku` | Quick searches, simple tasks | Lowest |
| `sonnet` | Most coding tasks, balanced | Medium |
| `opus` | Complex reasoning, architecture | Highest |

### Background Tasks

For long-running tasks, use `run_in_background: true`:
```
The agent will return an output_file path. Check progress with:
- Read tool to view the output file
- Bash with `tail -f` to follow output
```

---

## Planning Mode

For non-trivial implementation tasks, use Plan Mode.

### When to Enter Plan Mode

- New feature implementation
- Multiple valid approaches exist
- Architectural decisions required
- Changes affect multiple files
- Requirements are unclear

### Plan Mode Workflow

1. **Enter:** Use EnterPlanMode tool (requires user approval)
2. **Explore:** Use Glob, Grep, Read to understand codebase
3. **Design:** Write plan to designated plan file
4. **Clarify:** Use AskUserQuestion if needed
5. **Exit:** Use ExitPlanMode when plan is ready for approval
6. **Implement:** After user approves, execute the plan

### When NOT to Use Plan Mode

- Single-line fixes
- Typo corrections
- Adding a single function with clear requirements
- Pure research tasks (use Explore agent instead)

---

## Interactive Clarification

Use `AskUserQuestion` tool when you need:

- User preferences or requirements
- Clarification on ambiguous instructions
- Decisions on implementation choices
- Input on direction to take

**Format:**
- 1-4 questions per invocation
- 2-4 options per question
- Use multiSelect: true when choices aren't mutually exclusive
- Users can always select "Other" for custom input

---

## Session Continuity Protocol

### Required Files

| File | Purpose | When to Update |
|------|---------|----------------|
| `PROJECT_STATE.md` | Current system status | After each feature completion |
| `SESSION_LOG.md` | Detailed work tracking | Every session, append-only |
| `CONTINUATION_GUIDE.md` | Quick-start commands | When workflow changes |

### Session Startup Protocol

**1. Read these first (in order):**
```
PROJECT_STATE.md      → Current system status
SESSION_LOG.md        → Recent work and next steps
CONTINUATION_GUIDE.md → Quick start commands
```

**2. Check current state:**
```bash
git status                  # Uncommitted changes?
ps aux | grep python        # Running processes?
```

### End-of-Session Checklist

1. [ ] Update `SESSION_LOG.md` with work completed
2. [ ] Check for uncommitted changes: `git status`
3. [ ] If changes made, commit with descriptive message
4. [ ] Note any running background jobs
5. [ ] List next steps in SESSION_LOG.md

---

## MANDATORY ENGINEERING WORKFLOW

### The Three Pillars

Every production code change MUST include ALL THREE:

1. **TESTS** - Comprehensive unit tests that prove functionality
2. **DOCUMENTATION** - Clear docstrings and comments for complex logic
3. **GIT COMMITS** - Proper version control with descriptive messages

### Testing Requirements

- Write tests BEFORE or WITH implementation
- Use pytest for Python code
- Aim for >80% code coverage
- Test success paths AND failure paths
- Mock external dependencies

```bash
pytest test_my_feature.py -v
# Must see: ====== X passed in X.XXs ======
```

### Documentation Requirements

- Add module-level docstrings explaining purpose
- Add function docstrings (Args, Returns, Raises)
- Add inline comments for complex logic only

```python
def process_data(input_data: dict) -> dict:
    """
    Process raw input data and return formatted output.

    Args:
        input_data: Dictionary containing raw data fields

    Returns:
        Formatted data dictionary with processed fields

    Raises:
        ValueError: If required fields are missing
    """
```

### Git Commit Requirements

- Commit after each logical unit of work
- Write descriptive commit messages
- Use conventional commits format

```bash
git commit -m "feat: Add data processing pipeline

- Implemented process_data() with validation
- Added error handling for missing fields
- Created 5 unit tests for edge cases

Co-Authored-By: Claude <noreply@anthropic.com>"
```

### The Workflow

1. **Plan** - Understand requirements, design solution
2. **Implement** - Write the code
3. **Test** - Write and run comprehensive tests
4. **Document** - Add docstrings and comments
5. **Verify** - Run tests, review code
6. **Commit** - Git commit with descriptive message

**NO EXCEPTIONS. NO SHORTCUTS.**

---

## Task Management

Use the `TodoWrite` tool to track multi-step tasks.

### When to Use TodoWrite

- Complex tasks with 3+ steps
- User provides multiple tasks
- Need to track progress visibly
- Multi-file changes

### When NOT to Use TodoWrite

- Single straightforward task
- Trivial changes
- Purely informational requests

### Task States

- `pending` - Not yet started
- `in_progress` - Currently working (limit to ONE at a time)
- `completed` - Finished successfully

**Mark tasks complete IMMEDIATELY after finishing.**

---

## Code Conventions

- Files: `snake_case.py`
- Classes: `PascalCase`
- Functions: `snake_case`
- Use type hints for function signatures
- Use pathlib for file operations
- Use parameterized queries for SQL (never string formatting)

---

## File Structure

```
PROJECT_NAME_PLACEHOLDER/
├── CLAUDE.md              # THIS FILE - session quick ref
├── PROJECT_STATE.md       # System status
├── SESSION_LOG.md         # Work tracking
├── CONTINUATION_GUIDE.md  # Resume commands
├── agents.md              # Agent instructions
├── skills.md              # Skills reference
├── STANDARDS.md           # Protocol reference
├── src/                   # Source code
├── tests/                 # Test files
├── docs/                  # Documentation
├── scripts/               # Utility scripts
└── .claude/
    ├── settings.json      # MCP and permissions
    └── skills/            # Custom skills
```

---

## Quick Command Reference

| Task | Command |
|------|---------|
| Run tests | `pytest -v` |
| Check coverage | `pytest --cov=src` |
| Git status | `git status` |
| View recent commits | `git log --oneline -10` |
| Check deployments | `gh run list --limit 3` |

---

## Related Documentation

- `agents.md` - Detailed agent instructions
- `skills.md` - Available skills and commands
- `STANDARDS.md` - MCP, protocols reference
- `docs/ARCHITECTURE.md` - System design decisions

---

*Last updated: DATE_PLACEHOLDER*
CLAUDE_EOF

# Replace placeholders
sed -i '' "s/PROJECT_NAME_PLACEHOLDER/$PROJECT_NAME/g" CLAUDE.md
sed -i '' "s/PROJECT_DESC_PLACEHOLDER/$PROJECT_DESC/g" CLAUDE.md
sed -i '' "s/DATE_PLACEHOLDER/$CURRENT_DATE/g" CLAUDE.md

echo -e "${GREEN}✓ Created CLAUDE.md${NC}"

# ============================================================================
# Create PROJECT_STATE.md
# ============================================================================
cat > PROJECT_STATE.md << EOF
# $PROJECT_NAME - Project State

**Last Updated:** $CURRENT_DATE

---

## System Status

| Component | Status | Notes |
|-----------|--------|-------|
| Core functionality | Not Started | - |
| Tests | Not Started | - |
| Documentation | In Progress | CLAUDE.md created |
| Cloud Deployment | Not Configured | - |

---

## Current Production State

- **Version:** 0.0.0
- **Environment:** Local development
- **URL:** N/A

---

## Critical Files

| File | Purpose | Do Not Break |
|------|---------|--------------|
| CLAUDE.md | Session reference | Yes |
| .claude/settings.json | MCP configuration | Yes |

---

## Recent Changes

- $CURRENT_DATE: Project initialized with Claude Code setup v2.0

---

## Known Issues

None yet.

---

## Next Milestone

Define initial project scope and requirements.
EOF

echo -e "${GREEN}✓ Created PROJECT_STATE.md${NC}"

# ============================================================================
# Create SESSION_LOG.md
# ============================================================================
cat > SESSION_LOG.md << EOF
# $PROJECT_NAME - Session Log

Append-only log of work sessions. Most recent at top.

---

## Session: $CURRENT_DATE

### Summary
- Initialized project with Claude Code setup v2.0
- Created all standard project files
- Set up directory structure with .claude/ configuration

### Files Created
- CLAUDE.md - Main session reference
- PROJECT_STATE.md - System status
- SESSION_LOG.md - This file
- CONTINUATION_GUIDE.md - Resume guide
- agents.md - Agent instructions
- skills.md - Skills reference
- STANDARDS.md - Protocol reference
- .claude/settings.json - MCP configuration
- .claude/skills/commit/SKILL.md - Example commit skill
- .gitignore - Git ignore rules

### Decisions Made
- Using Claude Code v2.0 project structure
- Following Three Pillars: Tests, Documentation, Git Commits
- Cloud-first development approach

### Next Steps
- [ ] Define project requirements
- [ ] Set up development environment
- [ ] Create initial implementation plan
- [ ] Configure any needed MCP servers

### Open Questions
- None yet

---
EOF

echo -e "${GREEN}✓ Created SESSION_LOG.md${NC}"

# ============================================================================
# Create CONTINUATION_GUIDE.md
# ============================================================================
cat > CONTINUATION_GUIDE.md << 'EOF'
# PROJECT_NAME_PLACEHOLDER - Continuation Guide

Quick reference for resuming work on this project.

---

## Startup Commands

```bash
# 1. Check git status
git status

# 2. Check for running processes
ps aux | grep python

# 3. Run tests (when they exist)
pytest -v

# 4. Check recent deployments (if using GitHub Actions)
gh run list --limit 3
```

---

## State Verification

1. Read PROJECT_STATE.md for current status
2. Read SESSION_LOG.md for recent work and next steps
3. Check git log for recent commits: `git log --oneline -5`

---

## Key Workflows

### Adding a New Feature
1. Update SESSION_LOG.md with what you're starting
2. Use EnterPlanMode for complex features
3. Implement the feature
4. Write tests
5. Run tests: `pytest -v`
6. Commit with descriptive message
7. Update PROJECT_STATE.md if needed

### Fixing a Bug
1. Reproduce the bug
2. Write a failing test
3. Fix the bug
4. Verify test passes
5. Commit with `fix:` prefix

### Exploring the Codebase
Use the Explore subagent:
- "Find where authentication is handled"
- "Show me the database schema"
- "What files handle API requests?"

### Planning Implementation
Use the Plan subagent:
- "Design the architecture for feature X"
- "What's the best approach for Y?"

---

## Important Files

| File | Purpose |
|------|---------|
| CLAUDE.md | Main reference doc (read at session start) |
| PROJECT_STATE.md | Current system status |
| SESSION_LOG.md | Work history and next steps |
| .claude/settings.json | MCP server configuration |

---

## Subagent Quick Reference

| Need | Subagent | Example |
|------|----------|---------|
| Find files | Explore | "Where is the login handler?" |
| Design approach | Plan | "How should I implement caching?" |
| Git operations | Bash | Commits, pushes, branches |
| Complex research | general-purpose | Multi-step investigations |

---

## Environment Setup

```bash
# Python virtual environment
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

---

*Update this file when workflows change*
EOF

sed -i '' "s/PROJECT_NAME_PLACEHOLDER/$PROJECT_NAME/g" CONTINUATION_GUIDE.md

echo -e "${GREEN}✓ Created CONTINUATION_GUIDE.md${NC}"

# ============================================================================
# Create agents.md - Comprehensive Agent Instructions
# ============================================================================
cat > agents.md << 'AGENTS_EOF'
# PROJECT_NAME_PLACEHOLDER - Agent Instructions

**Purpose:** Authoritative guide for AI agents working on this project.

---

## Project Overview

PROJECT_DESC_PLACEHOLDER

---

## Subagent Architecture

Claude Code uses specialized subagents for different tasks. Each has specific capabilities and tools.

### Subagent Types

#### Explore Agent
**Purpose:** Fast codebase exploration
**Tools:** Glob, Grep, Read
**Best For:**
- Finding files by pattern
- Searching code for keywords
- Understanding codebase structure
- Quick answers about implementation

**Thoroughness Levels:**
- `quick` - Basic searches
- `medium` - Moderate exploration
- `very thorough` - Comprehensive analysis

**Example Uses:**
- "Find all API endpoints"
- "Where is error handling implemented?"
- "Show me the database models"

#### Plan Agent
**Purpose:** Designing implementation strategies
**Tools:** All tools
**Best For:**
- Architecture decisions
- Implementation planning
- Identifying critical files
- Considering trade-offs

**Example Uses:**
- "Design the caching strategy"
- "Plan the migration approach"
- "How should we restructure this module?"

#### Bash Agent
**Purpose:** Command execution
**Tools:** Bash only
**Best For:**
- Git operations
- Running builds
- System commands
- Terminal tasks

**Example Uses:**
- "Commit these changes"
- "Run the test suite"
- "Check deployment status"

#### General-Purpose Agent
**Purpose:** Complex multi-step tasks
**Tools:** All tools
**Best For:**
- Research requiring multiple tools
- Tasks spanning multiple concerns
- Anything that doesn't fit other categories

### Model Selection for Subagents

| Task Complexity | Model | Reasoning |
|-----------------|-------|-----------|
| Simple searches | haiku | Fast, cheap |
| Most coding | sonnet | Balanced |
| Architecture | opus | Deep reasoning |

### Running Agents in Background

For long tasks, use `run_in_background: true`:
- Agent returns immediately with output_file path
- Check progress: `Read` the output file or `tail -f`
- Continue working while agent runs

### Parallel Agent Execution

When tasks are independent, launch multiple agents in a single message:
- Each gets its own Task tool call
- All run concurrently
- Results return as they complete

---

## Development Environment

### Python Environment
- Python 3.x with virtual environment at `venv/`
- Activate before running scripts: `source venv/bin/activate`
- Install dependencies: `pip install -r requirements.txt`

### Required Environment Variables
```bash
# Add your environment variables here
# export API_KEY="your-key-here"
# export DATABASE_URL="your-connection-string"
```

---

## Code Conventions

### File Naming
- Python files: `snake_case.py`
- Classes: `PascalCase`
- Functions: `snake_case`
- Documentation: `SCREAMING_SNAKE_CASE.md`

### Import Standards
```python
import os
import sys
import json
from pathlib import Path
from datetime import datetime
from typing import Dict, List, Optional
```

### Error Handling
- Always use try/except for API calls
- Log errors with context
- Return meaningful error messages
- Never fail silently

---

## Database Best Practices

```python
# CORRECT - parameterized queries
cursor.execute("SELECT * FROM users WHERE id = %s", (user_id,))

# WRONG - SQL injection risk
cursor.execute(f"SELECT * FROM users WHERE id = '{user_id}'")
```

---

## Planning Mode Protocol

### When to Use EnterPlanMode

1. New feature implementation
2. Multiple valid approaches exist
3. Architectural decisions required
4. Changes affect 3+ files
5. Requirements need clarification

### Plan Mode Steps

1. **Enter:** EnterPlanMode (requires user consent)
2. **Explore:** Understand existing code
3. **Design:** Write detailed plan
4. **Clarify:** AskUserQuestion if needed
5. **Exit:** ExitPlanMode for approval
6. **Implement:** Execute approved plan

### Plan File Location

Plans are written to a designated file (specified in plan mode system message).

---

## Interactive Clarification

### Using AskUserQuestion

When you need user input during execution:

```
Questions: 1-4 per invocation
Options: 2-4 per question
multiSelect: true when choices aren't exclusive
```

**Good Uses:**
- Choosing between implementation approaches
- Confirming ambiguous requirements
- Getting preferences

**Bad Uses:**
- Asking "Is my plan okay?" (use ExitPlanMode instead)
- Asking about things you could research

---

## Testing Requirements

### Before Committing Code
1. Write unit tests for new functionality
2. Run all tests: `pytest -v`
3. Ensure >80% coverage for new code
4. Mock external dependencies

### Test File Structure
```
tests/
├── test_module_name.py
├── conftest.py          # Shared fixtures
└── fixtures/            # Test data
```

---

## Git Workflow

### Commit Message Format
```
<type>: <subject>

<body>

Co-Authored-By: Claude <noreply@anthropic.com>
```

### Commit Types
- `feat:` - New feature
- `fix:` - Bug fix
- `docs:` - Documentation changes
- `refactor:` - Code refactoring
- `test:` - Test additions/changes
- `chore:` - Maintenance tasks

### Git Safety Rules
- NEVER update git config
- NEVER force push to main/master
- NEVER skip hooks unless explicitly requested
- NEVER amend commits that have been pushed

---

## Session Protocol

### At Start of Session
1. Read `PROJECT_STATE.md` for current status
2. Read `SESSION_LOG.md` for recent work
3. Check `git status`
4. Check for running processes

### During Session
- Use `TodoWrite` for multi-step tasks
- Commit work frequently
- Update documentation as you go

### At End of Session
1. Update `SESSION_LOG.md`
2. Commit uncommitted changes
3. Note running background jobs
4. List next steps

---

## Security Rules

### Never Commit
- API keys or secrets
- Database passwords
- Private keys (*.pem, *.key)
- Environment files (.env.local)

### Always Use
- Environment variables for secrets
- .gitignore for sensitive files
- Parameterized queries for SQL

---

## Documentation References

- `CLAUDE.md` - Session quick reference
- `PROJECT_STATE.md` - Current system status
- `SESSION_LOG.md` - Work history
- `CONTINUATION_GUIDE.md` - Resume guide
- `skills.md` - Available skills/commands
- `STANDARDS.md` - Protocol references

---

*Last updated: DATE_PLACEHOLDER*
AGENTS_EOF

sed -i '' "s/PROJECT_NAME_PLACEHOLDER/$PROJECT_NAME/g" agents.md
sed -i '' "s/PROJECT_DESC_PLACEHOLDER/$PROJECT_DESC/g" agents.md
sed -i '' "s/DATE_PLACEHOLDER/$CURRENT_DATE/g" agents.md

echo -e "${GREEN}✓ Created agents.md${NC}"

# ============================================================================
# Create skills.md - Skills & Commands Reference
# ============================================================================
cat > skills.md << 'SKILLS_EOF'
# PROJECT_NAME_PLACEHOLDER - Skills & Commands Reference

**Purpose:** Document available skills, slash commands, and automation capabilities.

---

## What Are Skills?

Skills are pre-defined workflows that Claude Code can execute. They:
- Automate complex multi-step tasks
- Enforce consistent quality standards
- Provide project-specific capabilities
- Are invoked with `/skill-name` syntax

---

## Skill Architecture

### Skill Location
Skills are defined in `.claude/skills/` directory:

```
.claude/
└── skills/
    └── my-skill/
        └── SKILL.md      # Skill definition
```

### SKILL.md Structure

```markdown
# Skill Name

**Purpose:** What this skill does
**Invoke:** /skill-name or describe when auto-invoked

## Trigger
When to use this skill

## Steps
1. Step one
2. Step two
3. Step three

## Blocking Gates
Conditions that must pass before proceeding

## Inputs
- `param1`: Description

## Outputs
- What the skill produces

## Example Usage
/skill-name --param1 value
```

---

## Built-in Claude Code Commands

These are always available:

| Command | Description |
|---------|-------------|
| `/help` | Show available commands |
| `/clear` | Clear conversation |
| `/compact` | Reduce context size |
| `/config` | View/edit configuration |
| `/cost` | Show token usage |
| `/doctor` | Diagnose issues |
| `/init` | Initialize Claude Code |
| `/memory` | Manage memory |
| `/mcp` | MCP server management |
| `/pr-comments` | Review PR comments |
| `/review` | Code review |
| `/terminal-setup` | Configure terminal |
| `/vim` | Toggle vim mode |

---

## Project Skills

### /commit
**Purpose:** Create properly formatted git commit
**Location:** `.claude/skills/commit/SKILL.md`

**Steps:**
1. Check git status
2. Review staged and unstaged changes
3. Check recent commit messages for style
4. Generate descriptive commit message
5. Create commit with Co-Authored-By footer

### /test
**Purpose:** Run test suite with coverage

**Steps:**
1. Activate virtual environment
2. Run pytest with coverage
3. Report results and failures

### /deploy
**Purpose:** Deploy to production (if configured)

**Steps:**
1. Run tests
2. Check for uncommitted changes
3. Push to trigger CI/CD
4. Verify deployment status

---

## Creating Custom Skills

### 1. Create Skill Directory
```bash
mkdir -p .claude/skills/my-skill
```

### 2. Create SKILL.md
```markdown
# My Skill

**Purpose:** Description of what skill does
**Invoke:** /my-skill

## When to Use
Trigger conditions

## Steps
1. First step
2. Second step

## Blocking Gates
Conditions that must pass

## Rollback
What to do if skill fails
```

### 3. Test the Skill
```
/my-skill
```

---

## Skill Best Practices

### DO
- Include clear purpose statement
- Define blocking gates
- Include rollback procedures
- Document inputs/outputs
- Provide usage examples

### DON'T
- Create skills for one-step tasks
- Skip error handling
- Hardcode credentials
- Create overlapping skills

---

## Skill Integration with Tools

### Using TodoWrite in Skills
```markdown
## Steps
1. Create todo list for sub-tasks
2. Execute each task, marking complete
3. Final verification
```

### Using Subagents in Skills
```markdown
## Steps
1. Use Explore agent to find relevant files
2. Use Plan agent if architecture needed
3. Implement changes
4. Use Bash agent for git operations
```

---

## Skill Execution Flow

```
User invokes /skill-name
        ↓
Claude loads SKILL.md
        ↓
Check blocking gates
        ↓
    [Pass?]──No──→ Report failure, stop
        ↓ Yes
Execute steps in order
        ↓
    [Success?]──No──→ Execute rollback
        ↓ Yes
Report completion
```

---

*Update this file when adding new skills*

*Last updated: DATE_PLACEHOLDER*
SKILLS_EOF

sed -i '' "s/PROJECT_NAME_PLACEHOLDER/$PROJECT_NAME/g" skills.md
sed -i '' "s/DATE_PLACEHOLDER/$CURRENT_DATE/g" skills.md

echo -e "${GREEN}✓ Created skills.md${NC}"

# ============================================================================
# Create STANDARDS.md - Protocols Reference
# ============================================================================
cat > STANDARDS.md << 'STANDARDS_EOF'
# AI Agent Standards & Protocols Reference

**Purpose:** Reference guide for AI/agent protocols and standards.

---

## Model Context Protocol (MCP)

### What is MCP?
Model Context Protocol is Anthropic's open standard for connecting AI assistants to external data sources and tools.

### MCP Architecture

```
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│   AI Assistant  │────▶│   MCP Client    │────▶│   MCP Server    │
│  (Claude Code)  │◀────│   (Built-in)    │◀────│  (Your tools)   │
└─────────────────┘     └─────────────────┘     └─────────────────┘
                                                        │
                                                        ▼
                                               ┌─────────────────┐
                                               │  External Data  │
                                               │  - Databases    │
                                               │  - APIs         │
                                               │  - Files        │
                                               └─────────────────┘
```

### Common MCP Servers

| Type | Package | Use |
|------|---------|-----|
| Filesystem | `@modelcontextprotocol/server-filesystem` | File access |
| PostgreSQL | `@modelcontextprotocol/server-postgres` | Database |
| Git | `@modelcontextprotocol/server-git` | Git operations |
| Memory | `@modelcontextprotocol/server-memory` | Persistent memory |

### Configuring MCP Servers

In `.claude/settings.json`:
```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/allowed/path"]
    }
  }
}
```

### MCP Commands
```
/mcp                    # List configured servers
/mcp add <server>       # Add a server
/mcp remove <server>    # Remove a server
```

### MCP Resources
- **Specification:** https://spec.modelcontextprotocol.io/
- **GitHub:** https://github.com/modelcontextprotocol
- **Server Registry:** https://github.com/modelcontextprotocol/servers

---

## Claude Code Tool System

### Core Tools

| Tool | Purpose |
|------|---------|
| Read | Read files |
| Write | Create files |
| Edit | Modify existing files |
| Glob | Find files by pattern |
| Grep | Search file contents |
| Bash | Execute commands |
| Task | Spawn subagents |
| TodoWrite | Track tasks |
| AskUserQuestion | Get user input |
| WebFetch | Fetch web content |
| WebSearch | Search the web |

### Specialized Tools

| Tool | Purpose |
|------|---------|
| EnterPlanMode | Start planning workflow |
| ExitPlanMode | Submit plan for approval |
| NotebookEdit | Edit Jupyter notebooks |
| Skill | Execute defined skills |

---

## Anthropic Agent SDK

### Basic Structure

```python
import anthropic

client = anthropic.Anthropic()

tools = [
    {
        "name": "search_database",
        "description": "Search the project database",
        "input_schema": {
            "type": "object",
            "properties": {
                "query": {"type": "string"}
            },
            "required": ["query"]
        }
    }
]

response = client.messages.create(
    model="claude-sonnet-4-20250514",
    max_tokens=4096,
    tools=tools,
    messages=[{"role": "user", "content": "Search for X"}]
)
```

### Available Models (January 2026)

| Model | ID | Best For |
|-------|-----|----------|
| Claude Opus 4.5 | claude-opus-4-5-20251101 | Complex reasoning |
| Claude Sonnet 4 | claude-sonnet-4-20250514 | Balanced tasks |
| Claude Haiku 3.5 | claude-3-5-haiku-20241022 | Fast, simple tasks |

### Resources
- **Documentation:** https://docs.anthropic.com/en/docs/agents
- **SDK:** https://github.com/anthropics/anthropic-sdk-python
- **Cookbook:** https://github.com/anthropics/anthropic-cookbook

---

## GitHub Actions for Deployment

### Basic Workflow

```yaml
name: Deploy

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Deploy
        run: ./scripts/deploy.sh
        env:
          API_KEY: ${{ secrets.API_KEY }}
```

### Check Deployment Status
```bash
gh run list --limit 3
```

---

## Security Best Practices

### All Protocols
- Use environment variables for credentials
- Implement rate limiting
- Log all agent actions
- Validate all inputs
- Never hardcode secrets
- Never trust agent output without validation

### MCP-Specific
- Limit filesystem access to specific directories
- Use read-only mode when possible
- Audit server configurations regularly

---

*Last updated: DATE_PLACEHOLDER*
STANDARDS_EOF

sed -i '' "s/DATE_PLACEHOLDER/$CURRENT_DATE/g" STANDARDS.md

echo -e "${GREEN}✓ Created STANDARDS.md${NC}"

# ============================================================================
# Create .claude/settings.json - MCP Configuration
# ============================================================================
mkdir -p .claude

cat > .claude/settings.json << 'EOF'
{
  "mcpServers": {

  },
  "permissions": {
    "allow": [],
    "deny": []
  },
  "hooks": {

  }
}
EOF

echo -e "${GREEN}✓ Created .claude/settings.json${NC}"

# ============================================================================
# Create example skill: commit
# ============================================================================
mkdir -p .claude/skills/commit

cat > .claude/skills/commit/SKILL.md << 'EOF'
# Commit Skill

**Purpose:** Create properly formatted git commits with consistent style.
**Invoke:** /commit or when user asks to commit changes

---

## When to Use

- User explicitly asks to commit
- After completing a feature or fix
- When work reaches a logical checkpoint

## Blocking Gates

1. Must have changes to commit (staged or unstaged)
2. Must not have merge conflicts
3. Tests should pass (if test suite exists)

## Steps

1. **Check Status**
   - Run `git status` to see all changes
   - Run `git diff` to review unstaged changes
   - Run `git diff --staged` to review staged changes

2. **Review Recent Style**
   - Run `git log --oneline -5` to see recent commit messages
   - Match the project's commit message style

3. **Stage Changes**
   - Stage relevant files with `git add`
   - Do NOT stage files that contain secrets

4. **Generate Message**
   - Use conventional commits format: `type: subject`
   - Types: feat, fix, docs, refactor, test, chore
   - Include body explaining what and why
   - Add Co-Authored-By footer

5. **Create Commit**
   ```bash
   git commit -m "$(cat <<'COMMIT_EOF'
   type: Short description

   - Detailed point 1
   - Detailed point 2

   Co-Authored-By: Claude <noreply@anthropic.com>
   COMMIT_EOF
   )"
   ```

6. **Verify**
   - Run `git status` to confirm commit succeeded
   - Run `git log -1` to review the commit

## Safety Rules

- NEVER commit files containing secrets
- NEVER use --force or --no-verify
- NEVER amend pushed commits without explicit permission
- ALWAYS use HEREDOC for multi-line messages

## Example Output

```
feat: Add user authentication system

- Implemented JWT-based auth with refresh tokens
- Added login/logout API endpoints
- Created middleware for protected routes
- Added 12 unit tests for auth flows

Co-Authored-By: Claude <noreply@anthropic.com>
```
EOF

echo -e "${GREEN}✓ Created .claude/skills/commit/SKILL.md${NC}"

# ============================================================================
# Create .gitignore
# ============================================================================
if [ ! -f .gitignore ]; then
cat > .gitignore << 'EOF'
# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
venv/
env/
.venv/
.env
.env.local

# IDE
.idea/
.vscode/
*.swp
*.swo
*~

# OS
.DS_Store
Thumbs.db

# Testing
.coverage
htmlcov/
.pytest_cache/
.tox/

# Build
build/
dist/
*.egg-info/

# Data
*.db
*.sqlite
*.sqlite3

# Logs
*.log
logs/

# Credentials (NEVER commit)
credentials/
*.pem
*.key
secrets.json
token.json

# Node
node_modules/
EOF

echo -e "${GREEN}✓ Created .gitignore${NC}"
else
echo -e "${YELLOW}⊘ .gitignore already exists, skipping${NC}"
fi

# ============================================================================
# Create directory structure
# ============================================================================
mkdir -p src tests docs scripts .claude/skills

echo -e "${GREEN}✓ Created directories: src/, tests/, docs/, scripts/, .claude/skills/${NC}"

# ============================================================================
# Create GitHub Actions workflow template
# ============================================================================
mkdir -p .github/workflows

cat > .github/workflows/ci.yml << 'EOF'
name: CI

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - name: Set up Python
        uses: actions/setup-python@v5
        with:
          python-version: '3.11'

      - name: Install dependencies
        run: |
          python -m pip install --upgrade pip
          pip install pytest pytest-cov
          if [ -f requirements.txt ]; then pip install -r requirements.txt; fi

      - name: Run tests
        run: |
          pytest -v --cov=src --cov-report=xml

      - name: Upload coverage
        uses: codecov/codecov-action@v3
        with:
          files: ./coverage.xml
EOF

echo -e "${GREEN}✓ Created .github/workflows/ci.yml${NC}"

# ============================================================================
# Initialize git if not already a repo
# ============================================================================
if [ ! -d .git ]; then
    echo ""
    echo -e "${YELLOW}Initialize git repository? (y/n):${NC}"
    read -r INIT_GIT
    if [ "$INIT_GIT" = "y" ] || [ "$INIT_GIT" = "Y" ]; then
        git init
        git add .
        git commit -m "chore: Initialize project with Claude Code setup v2.0

Project Files:
- CLAUDE.md - Session reference with subagent docs
- PROJECT_STATE.md - Status tracking
- SESSION_LOG.md - Work logging
- CONTINUATION_GUIDE.md - Resume guide
- agents.md - Comprehensive agent instructions
- skills.md - Skills & commands reference
- STANDARDS.md - MCP & protocols reference

Configuration:
- .claude/settings.json - MCP server config
- .claude/skills/commit/ - Example commit skill
- .github/workflows/ci.yml - CI pipeline

Features in v2.0:
- Subagent documentation (Explore, Plan, Bash, general-purpose)
- Model selection guidance (haiku, sonnet, opus)
- Planning mode workflow
- Cloud-first development patterns
- Background task management
- Interactive clarification tools

Co-Authored-By: Claude <noreply@anthropic.com>"
        echo -e "${GREEN}✓ Initialized git repository and made initial commit${NC}"
    fi
else
    echo -e "${YELLOW}⊘ Git repository already exists${NC}"
fi

# ============================================================================
# Summary
# ============================================================================
echo ""
echo -e "${BLUE}========================================${NC}"
echo -e "${GREEN}  Setup Complete! (v2.0)${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo -e "Created files:"
echo -e "  ${GREEN}✓${NC} CLAUDE.md              - Main session reference"
echo -e "  ${GREEN}✓${NC} PROJECT_STATE.md       - System status tracking"
echo -e "  ${GREEN}✓${NC} SESSION_LOG.md         - Work session logging"
echo -e "  ${GREEN}✓${NC} CONTINUATION_GUIDE.md  - Resume work guide"
echo -e "  ${GREEN}✓${NC} agents.md              - Agent instructions"
echo -e "  ${GREEN}✓${NC} skills.md              - Skills & commands"
echo -e "  ${GREEN}✓${NC} STANDARDS.md           - Protocols reference"
echo -e "  ${GREEN}✓${NC} .claude/settings.json  - MCP configuration"
echo -e "  ${GREEN}✓${NC} .claude/skills/commit/ - Example skill"
echo -e "  ${GREEN}✓${NC} .github/workflows/ci.yml - CI pipeline"
echo -e "  ${GREEN}✓${NC} .gitignore             - Git ignore rules"
echo ""
echo -e "Created directories:"
echo -e "  ${GREEN}✓${NC} src/            - Source code"
echo -e "  ${GREEN}✓${NC} tests/          - Test files"
echo -e "  ${GREEN}✓${NC} docs/           - Documentation"
echo -e "  ${GREEN}✓${NC} scripts/        - Utility scripts"
echo -e "  ${GREEN}✓${NC} .claude/skills/ - Custom skills"
echo -e "  ${GREEN}✓${NC} .github/workflows/ - CI/CD"
echo ""
echo -e "${CYAN}v2.0 Features:${NC}"
echo -e "  • Subagent documentation (Explore, Plan, Bash, general-purpose)"
echo -e "  • Model selection guidance (haiku, sonnet, opus)"
echo -e "  • Planning mode workflow"
echo -e "  • Cloud-first development patterns"
echo -e "  • Background task management"
echo -e "  • MCP server configuration"
echo -e "  • GitHub Actions CI template"
echo ""
echo -e "${BLUE}Next steps:${NC}"
echo -e "  1. cd $PROJECT_DIR"
echo -e "  2. Start Claude Code: claude"
echo -e "  3. Claude will auto-load CLAUDE.md"
echo ""
