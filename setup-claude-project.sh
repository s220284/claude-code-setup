#!/bin/bash
#
# Claude Code Project Setup Script v4.0
# Creates CLAUDE.md and supporting files for new projects
#
# Usage: ./setup-claude-project.sh [project_name] [project_description]
#
# Example:
#   ./setup-claude-project.sh MyApp "A web application for task management"
#   ./setup-claude-project.sh  # Interactive mode
#
# Version: 4.0.0
# Updated: February 2026
# Changes: Hooks, modular rules, auto-memory, language-agnostic, slimmer CLAUDE.md
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
echo -e "${BLUE}  Claude Code Project Setup v4.0${NC}"
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
# Create CLAUDE.md - Main Session Reference (~80-100 lines)
# ============================================================================
cat > CLAUDE.md << 'CLAUDE_EOF'
# CLAUDE.md

**Project:** PROJECT_DESC_PLACEHOLDER

---

## CRITICAL: Cloud-First Development

This application runs in cloud environments (AWS/GCP/Azure).

**Never hardcode local paths:**
```
# WRONG
path = "/Users/username/projects/myapp"

# CORRECT
path = env_var("APP_ROOT", "/app")  # Use your language's equivalent
```

**Before writing code, verify:**
1. Paths work in containers (use relative paths or env vars)
2. Credentials come from environment variables
3. No local filesystem dependencies

---

## Engineering Requirements (Three Pillars)

Every production code change MUST include:

1. **Tests** — Run your test suite, aim for >80% coverage, test success AND failure paths
2. **Documentation** — Docstrings/comments for public APIs
3. **Git Commits** — Conventional format with Co-Authored-By footer

No exceptions. No shortcuts.

---

## Modular Documentation

Detailed conventions live in `.claude/rules/` and are loaded automatically:

- `@import .claude/rules/code-style.md` — coding conventions (path-filtered to `src/**`)
- `@import .claude/rules/testing.md` — testing standards (path-filtered to `tests/**`)

Add more rules files as your project grows. Use `paths:` frontmatter to scope rules to specific directories.

> **Tip:** Run `/init` to let Claude analyze your codebase and generate additional project-specific instructions.

---

## Session Continuity

Claude Code's **auto-memory** handles session context automatically. For manual tracking:

| File | Purpose | Update When |
|------|---------|-------------|
| `PROJECT_STATE.md` | System status snapshot | After feature completion |

---

## Project Structure

```
PROJECT_NAME_PLACEHOLDER/
├── CLAUDE.md              # This file (auto-loaded)
├── CLAUDE.local.md        # Personal overrides (gitignored)
├── PROJECT_STATE.md       # System status
├── src/                   # Source code
├── tests/                 # Test files
├── docs/                  # Documentation
├── scripts/               # Utility scripts
└── .claude/
    ├── settings.json      # Shared configuration & hooks
    ├── settings.local.json # Personal overrides (gitignored)
    ├── rules/             # Modular rule files
    │   ├── code-style.md  # Coding conventions
    │   └── testing.md     # Testing standards
    └── skills/            # Custom skills
        └── commit/        # Commit workflow skill
```

---

## Available Skills & Plugins

### Local Skills (`.claude/skills/`)

- `/commit` — Git commit workflow with conventional format

### Global Plugins

| Plugin | Skills/Agents | Purpose |
|--------|---------------|---------|
| `commit-commands` | `/commit`, `/commit-push-pr`, `/clean_gone` | Git workflow automation |
| `feature-dev` | `/feature-dev` | Guided feature development |
| `pr-review-toolkit` | `/review-pr` + code-reviewer, silent-failure-hunter, type-design-analyzer | Comprehensive PR review |
| `frontend-design` | `/frontend-design` | Production-grade UI development |

> **Agent Teams** (experimental): For background multi-agent workflows, see Claude Code's agent teams feature — the successor to loop-based plugins.

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
| .claude/settings.json | Configuration & hooks | Yes |

---

## Recent Changes

- $CURRENT_DATE: Project initialized with Claude Code setup v4.0

---

## Known Issues

None yet.

---

## Next Milestone

Define initial project scope and requirements.
EOF

echo -e "${GREEN}✓ Created PROJECT_STATE.md${NC}"

# ============================================================================
# Create .claude/settings.json - Configuration with Hooks
# ============================================================================
mkdir -p .claude

cat > .claude/settings.json << 'EOF'
{
  "$schema": "https://json.schemastore.org/claude-code-settings.json",
  "permissions": {
    "allow": [
      "Bash(git status)",
      "Bash(git diff *)",
      "Bash(git log *)"
    ],
    "deny": [
      "Read(.env)",
      "Read(.env.*)"
    ]
  },
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write",
        "hooks": [
          {
            "type": "command",
            "command": "jq -r '.tool_input.file_path // empty' | xargs -I{} sh -c 'case \"{}\" in *.sh) sed -i \"\" \"s/\\r$//\" \"{}\" && chmod +x \"{}\" ;; esac'"
          }
        ]
      }
    ],
    "Notification": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "osascript -e 'display notification \"Claude Code needs your attention\" with title \"Claude Code\"' 2>/dev/null || true"
          }
        ]
      }
    ]
  }
}
EOF

echo -e "${GREEN}✓ Created .claude/settings.json${NC}"

# ============================================================================
# Create .claude/settings.local.json - Personal overrides (gitignored)
# ============================================================================
cat > .claude/settings.local.json << 'EOF'
{
  "$schema": "https://json.schemastore.org/claude-code-settings.json"
}
EOF

echo -e "${GREEN}✓ Created .claude/settings.local.json${NC}"

# ============================================================================
# Create .claude/rules/ - Modular rule files
# ============================================================================
mkdir -p .claude/rules

cat > .claude/rules/code-style.md << 'EOF'
---
paths:
  - "src/**"
---

# Code Style

<!-- Customize these conventions for your language and project -->

- Use consistent naming: `snake_case` for functions/variables, `PascalCase` for classes/types
- Keep functions focused — one responsibility per function
- Use environment variables for configuration, never hardcode secrets
- Prefer explicit over implicit — avoid magic numbers, use named constants
- Use parameterized queries for database operations (never string interpolation)
EOF

echo -e "${GREEN}✓ Created .claude/rules/code-style.md${NC}"

cat > .claude/rules/testing.md << 'EOF'
---
paths:
  - "tests/**"
---

# Testing Standards

<!-- Customize these standards for your test framework -->

- Every new feature or bug fix requires tests
- Test both success and failure paths
- Mock external dependencies (APIs, databases, filesystems)
- Use descriptive test names that explain the scenario
- Aim for >80% code coverage on new code
- Keep test files mirroring the source directory structure
EOF

echo -e "${GREEN}✓ Created .claude/rules/testing.md${NC}"

# ============================================================================
# Create commit skill with YAML frontmatter
# ============================================================================
mkdir -p .claude/skills/commit

cat > .claude/skills/commit/SKILL.md << 'EOF'
---
name: commit
description: Create properly formatted git commits
user-invocable: true
---

# Commit Skill

**Purpose:** Create properly formatted git commits with consistent style.

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
EOF

echo -e "${GREEN}✓ Created .claude/skills/commit/SKILL.md${NC}"

# ============================================================================
# Create .gitignore
# ============================================================================
if [ ! -f .gitignore ]; then
cat > .gitignore << 'EOF'
# Claude Code local overrides
CLAUDE.local.md
.claude/settings.local.json

# Environment
.env
.env.*
!.env.example

# IDE
.idea/
.vscode/
*.swp
*.swo
*~

# OS
.DS_Store
Thumbs.db

# Dependencies
node_modules/
vendor/
venv/
.venv/

# Build artifacts
build/
dist/
out/
*.egg-info/

# Testing / Coverage
.coverage
htmlcov/
coverage/
*.lcov

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
EOF

echo -e "${GREEN}✓ Created .gitignore${NC}"
else
echo -e "${YELLOW}⊘ .gitignore already exists, skipping${NC}"
fi

# ============================================================================
# Create directory structure
# ============================================================================
mkdir -p src tests docs scripts .claude/skills .claude/rules .claude/hooks .github/workflows

echo -e "${GREEN}✓ Created directories: src/, tests/, docs/, scripts/, .claude/{skills,rules,hooks}/, .github/workflows/${NC}"

# ============================================================================
# Create GitHub Actions workflow template (language-agnostic)
# ============================================================================
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

      # TODO: Add your language-specific setup steps here
      # Examples:
      #   - uses: actions/setup-node@v4
      #     with: { node-version: '20' }
      #   - uses: actions/setup-python@v5
      #     with: { python-version: '3.12' }
      #   - uses: actions/setup-go@v5
      #     with: { go-version: '1.22' }

      - name: Install dependencies
        run: echo "TODO: Add your install command (npm ci, pip install -r requirements.txt, etc.)"

      - name: Run tests
        run: echo "TODO: Add your test command (npm test, pytest -v, go test ./..., etc.)"
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
        git commit -m "chore: Initialize project with Claude Code setup v4.0

Project Files:
- CLAUDE.md - Session reference (slimmed down, language-agnostic)
- PROJECT_STATE.md - Status tracking

Configuration:
- .claude/settings.json - Permissions, hooks (shell fixer, notifications)
- .claude/settings.local.json - Personal overrides (gitignored)
- .claude/rules/code-style.md - Path-specific code conventions
- .claude/rules/testing.md - Path-specific testing standards
- .claude/skills/commit/ - Commit skill with YAML frontmatter
- .github/workflows/ci.yml - CI pipeline template

v4.0 Changes:
- Hooks: PostToolUse shell fixer, Notification alerts
- Modular rules with path-specific frontmatter
- Auto-memory replaces SESSION_LOG.md and CONTINUATION_GUIDE.md
- Language-agnostic (no Python-specific references)
- CLAUDE.md under 100 lines

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
echo -e "${GREEN}  Setup Complete! (v4.0)${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo -e "Created files:"
echo -e "  ${GREEN}✓${NC} CLAUDE.md                     - Main session reference (slimmed)"
echo -e "  ${GREEN}✓${NC} PROJECT_STATE.md              - System status tracking"
echo -e "  ${GREEN}✓${NC} .claude/settings.json         - Permissions & hooks"
echo -e "  ${GREEN}✓${NC} .claude/settings.local.json   - Personal overrides (gitignored)"
echo -e "  ${GREEN}✓${NC} .claude/rules/code-style.md   - Code conventions (path-specific)"
echo -e "  ${GREEN}✓${NC} .claude/rules/testing.md       - Testing standards (path-specific)"
echo -e "  ${GREEN}✓${NC} .claude/skills/commit/SKILL.md - Commit skill"
echo -e "  ${GREEN}✓${NC} .github/workflows/ci.yml      - CI pipeline template"
echo -e "  ${GREEN}✓${NC} .gitignore                    - Git ignore rules"
echo ""
echo -e "Created directories:"
echo -e "  ${GREEN}✓${NC} src/              - Source code"
echo -e "  ${GREEN}✓${NC} tests/            - Test files"
echo -e "  ${GREEN}✓${NC} docs/             - Documentation"
echo -e "  ${GREEN}✓${NC} scripts/          - Utility scripts"
echo -e "  ${GREEN}✓${NC} .claude/skills/   - Custom skills"
echo -e "  ${GREEN}✓${NC} .claude/rules/    - Modular rule files"
echo -e "  ${GREEN}✓${NC} .claude/hooks/    - Custom hooks"
echo -e "  ${GREEN}✓${NC} .github/workflows/ - CI/CD"
echo ""
echo -e "${CYAN}v4.0 Highlights:${NC}"
echo -e "  • Hooks — shell script fixer (PostToolUse) and notification alerts"
echo -e "  • Modular rules — path-specific conventions in .claude/rules/"
echo -e "  • Auto-memory — replaces SESSION_LOG.md and CONTINUATION_GUIDE.md"
echo -e "  • Language-agnostic — no Python-specific references"
echo -e "  • Slimmer CLAUDE.md — under 100 lines, focused on project-specific guidance"
echo -e "  • Agent teams — noted as successor to loop-based plugins"
echo ""
echo -e "${BLUE}Next steps:${NC}"
echo -e "  1. cd $PROJECT_DIR"
echo -e "  2. Customize .claude/rules/ for your language and framework"
echo -e "  3. Run /init to generate codebase-specific instructions"
echo -e "  4. Start Claude Code: claude"
echo ""
