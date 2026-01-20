#!/bin/bash
#
# Claude Code Project Setup Script v3.0
# Creates CLAUDE.md and supporting files for new projects
#
# Usage: ./setup-claude-project.sh [project_name] [project_description]
#
# Example:
#   ./setup-claude-project.sh MyApp "A web application for task management"
#   ./setup-claude-project.sh  # Interactive mode
#
# Version: 3.0.0
# Updated: January 2026
# Changes: Simplified template - removed redundant docs (agents.md, skills.md, STANDARDS.md)
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
echo -e "${BLUE}  Claude Code Project Setup v3.0${NC}"
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
# CLAUDE.md

**Project:** PROJECT_DESC_PLACEHOLDER

---

## CRITICAL: Shell Script Line Endings

The Write tool outputs CRLF line endings which break shell scripts on macOS/Linux.

**For ALL .sh files, IMMEDIATELY after writing:**
```bash
sed -i '' 's/\r$//' script.sh && chmod +x script.sh
```
Skipping this causes "bad interpreter" errors.

---

## CRITICAL: Cloud-First Development

This application runs in cloud environments (AWS/GCP/Azure).

**Never hardcode local paths:**
```python
# WRONG
path = '/Users/username/projects/myapp'

# CORRECT
import os
project_root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
path = os.environ.get('APP_ROOT', '/app')
```

**Before writing code, verify:**
1. Paths work in containers (use relative paths or env vars)
2. Credentials come from environment variables
3. No local filesystem dependencies

---

## Engineering Requirements

**Every production code change MUST include:**

1. **Tests** - pytest, >80% coverage, test success AND failure paths
2. **Documentation** - Docstrings with Args/Returns/Raises
3. **Git Commits** - Conventional format with Co-Authored-By footer

**No exceptions. No shortcuts.**

```bash
# Run tests before committing
pytest -v
```

---

## Session Continuity Protocol

### Session Files

| File | Purpose | Update When |
|------|---------|-------------|
| `PROJECT_STATE.md` | System status snapshot | After feature completion |
| `SESSION_LOG.md` | Work history (append-only) | Every session |
| `CONTINUATION_GUIDE.md` | Quick-start commands | When workflows change |

### Session Startup

1. Read: `PROJECT_STATE.md` → `SESSION_LOG.md` → `CONTINUATION_GUIDE.md`
2. Check: `git status` and `ps aux | grep python`

### Session Shutdown

1. Update `SESSION_LOG.md` with work completed and next steps
2. Commit any uncommitted changes
3. Note running background jobs

---

## Code Conventions

| Element | Convention |
|---------|------------|
| Files | `snake_case.py` |
| Classes | `PascalCase` |
| Functions | `snake_case` |
| Documentation | `SCREAMING_SNAKE_CASE.md` |

**Required:**
- Type hints for function signatures
- `pathlib` for file operations
- Parameterized queries for SQL (never f-strings)
- Environment variables for secrets

---

## Git Commit Format

```bash
git commit -m "$(cat <<'EOF'
type: Short description

- Detail 1
- Detail 2

Co-Authored-By: Claude <noreply@anthropic.com>
EOF
)"
```

**Types:** `feat`, `fix`, `docs`, `refactor`, `test`, `chore`

---

## Project Structure

```
PROJECT_NAME_PLACEHOLDER/
├── CLAUDE.md              # This file
├── PROJECT_STATE.md       # System status
├── SESSION_LOG.md         # Work history
├── CONTINUATION_GUIDE.md  # Resume guide
├── src/                   # Source code
├── tests/                 # Test files
├── scripts/               # Utility scripts
└── .claude/
    ├── settings.json      # Configuration
    ├── settings.local.json # Local overrides
    └── skills/            # Custom skills
        └── commit/        # Commit workflow skill
```

---

## Available Skills & Plugins

### Local Skills (`.claude/skills/`)

- `/commit` - Git commit workflow with conventional format

### Global Plugins

| Plugin | Skills/Agents | Purpose |
|--------|---------------|---------|
| `commit-commands` | `/commit`, `/commit-push-pr`, `/clean_gone` | Git workflow automation |
| `feature-dev` | `/feature-dev` | Guided feature development |
| `pr-review-toolkit` | `/review-pr` | PR review with code-reviewer, silent-failure-hunter, type-design-analyzer |
| `frontend-design` | `/frontend-design` | Production-grade UI development |
| `ralph-loop` | `/ralph-loop`, `/cancel-ralph` | Background processing loop |

### MCP Servers

- **Playwright** - Browser automation for testing and screenshots

---

## Quick Commands

| Task | Command |
|------|---------|
| Run tests | `pytest -v` |
| Coverage | `pytest --cov=src` |
| Git status | `git status` |
| Recent commits | `git log --oneline -5` |
| Check CI | `gh run list --limit 3` |

### Skill Shortcuts

| Task | Skill |
|------|-------|
| Commit changes | `/commit` |
| Commit, push, and create PR | `/commit-push-pr` |
| Review a PR | `/review-pr` |
| Build a UI component | `/frontend-design` |
| Clean deleted remote branches | `/clean_gone` |

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

- $CURRENT_DATE: Project initialized with Claude Code setup v3.0

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
- Initialized project with Claude Code setup v3.0
- Created all standard project files
- Set up directory structure with .claude/ configuration

### Files Created
- CLAUDE.md - Main session reference
- PROJECT_STATE.md - System status
- SESSION_LOG.md - This file
- CONTINUATION_GUIDE.md - Resume guide
- .claude/settings.json - MCP configuration
- .claude/skills/commit/SKILL.md - Commit skill
- .gitignore - Git ignore rules

### Decisions Made
- Using Claude Code v3.0 project structure (simplified)
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

---

## Important Files

| File | Purpose |
|------|---------|
| CLAUDE.md | Main reference doc (read at session start) |
| PROJECT_STATE.md | Current system status |
| SESSION_LOG.md | Work history and next steps |
| .claude/settings.json | MCP server configuration |

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
# Create commit skill
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
        git commit -m "chore: Initialize project with Claude Code setup v3.0

Project Files:
- CLAUDE.md - Session reference (simplified)
- PROJECT_STATE.md - Status tracking
- SESSION_LOG.md - Work logging
- CONTINUATION_GUIDE.md - Resume guide

Configuration:
- .claude/settings.json - MCP server config
- .claude/skills/commit/ - Commit skill
- .github/workflows/ci.yml - CI pipeline

v3.0 Changes:
- Removed redundant docs (agents.md, skills.md, STANDARDS.md)
- Claude Code has built-in knowledge of subagents, MCP, etc.
- CLAUDE.md now contains only project-specific guidance

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
echo -e "${GREEN}  Setup Complete! (v3.0)${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo -e "Created files:"
echo -e "  ${GREEN}✓${NC} CLAUDE.md              - Main session reference"
echo -e "  ${GREEN}✓${NC} PROJECT_STATE.md       - System status tracking"
echo -e "  ${GREEN}✓${NC} SESSION_LOG.md         - Work session logging"
echo -e "  ${GREEN}✓${NC} CONTINUATION_GUIDE.md  - Resume work guide"
echo -e "  ${GREEN}✓${NC} .claude/settings.json  - MCP configuration"
echo -e "  ${GREEN}✓${NC} .claude/skills/commit/ - Commit skill"
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
echo -e "${CYAN}v3.0 Improvements:${NC}"
echo -e "  • Simplified template - removed redundant documentation"
echo -e "  • CLAUDE.md contains only project-specific guidance"
echo -e "  • Global plugins documented (feature-dev, pr-review-toolkit, etc.)"
echo -e "  • Skill shortcuts table for common workflows"
echo ""
echo -e "${BLUE}Next steps:${NC}"
echo -e "  1. cd $PROJECT_DIR"
echo -e "  2. Start Claude Code: claude"
echo -e "  3. Claude will auto-load CLAUDE.md"
echo ""
