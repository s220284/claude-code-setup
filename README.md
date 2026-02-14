# Shelly Palmer's Claude Code Project Setup

A streamlined setup script and programmer's guide for AI-assisted development with [Claude Code](https://claude.ai/claude-code).

## What's Included

| File | Description |
|------|-------------|
| `setup-claude-project.sh` | Shell script that creates a complete Claude Code project structure |
| `index.html` | [Programmer's Guide](https://s220284.github.io/claude-code-setup/) with full documentation |

## Quick Start

```bash
# Download the setup script
curl -O https://raw.githubusercontent.com/s220284/claude-code-setup/main/setup-claude-project.sh

# Make it executable
chmod +x setup-claude-project.sh

# Run it in your project directory
./setup-claude-project.sh
```

## What the Script Creates

```
your-project/
├── CLAUDE.md                  # Main instructions file (auto-loaded by Claude)
├── PROJECT_STATE.md           # System status tracker
├── .claude/
│   ├── settings.json          # Permissions, hooks, configuration
│   ├── settings.local.json    # Personal overrides (gitignored)
│   ├── rules/
│   │   ├── code-style.md      # Code conventions (path-specific)
│   │   └── testing.md         # Testing standards (path-specific)
│   ├── hooks/                 # Custom hook scripts
│   └── skills/
│       └── commit/            # Commit workflow skill
├── .github/
│   └── workflows/
│       └── ci.yml             # GitHub Actions workflow template
├── src/                       # Source code
├── tests/                     # Test files
├── docs/                      # Documentation
└── scripts/                   # Utility scripts
```

## Key Features

- **Hooks**: PostToolUse hook auto-fixes shell script line endings; Notification hook sends macOS alerts when Claude needs attention
- **Modular Rules**: `.claude/rules/` directory with path-specific frontmatter (`paths: src/**`) for scoped conventions
- **Auto-Memory**: Claude Code's built-in memory replaces manual session logs — no more SESSION_LOG.md or CONTINUATION_GUIDE.md
- **Agent Teams**: Noted as the successor to loop-based plugins for multi-agent workflows
- **Language-Agnostic**: No Python-specific references — works with any tech stack
- **Slim CLAUDE.md**: Under 100 lines of focused, project-specific guidance
- **Global Plugins**: Documents commit-commands, feature-dev, pr-review-toolkit, and frontend-design
- **Cloud-First Patterns**: Best practices for cloud deployment
- **Skill Frontmatter**: YAML frontmatter on skills for proper registration

## Version 4.0 Improvements

v4.0 reflects how Claude Code features have matured since January 2026:

- **Hooks system**: Scaffolded PostToolUse and Notification hooks in `settings.json`
- **Modular rules**: `.claude/rules/` with `paths:` YAML frontmatter for path-specific loading
- **Auto-memory**: Replaces SESSION_LOG.md and CONTINUATION_GUIDE.md
- **Language-agnostic**: Removed all Python-specific code examples and references
- **Slimmer CLAUDE.md**: ~80 lines (down from ~180), focused on project-specific guidance
- **Updated plugins**: Removed ralph-loop, added agent teams note
- **Settings schema**: Added `$schema` reference, pre-configured permissions and deny rules
- **Skill frontmatter**: YAML metadata on skills for proper registration

## Programmer's Guide

The full documentation is available at: **[s220284.github.io/claude-code-setup](https://s220284.github.io/claude-code-setup/)**

The guide covers:
- Complete script walkthrough
- Hooks system and scaffolded hooks
- Modular rules with path-specific loading
- Each generated file explained
- Global plugins and skills reference
- Planning mode best practices
- Real-world usage examples

## Requirements

- macOS or Linux (WSL works on Windows)
- Bash shell
- [Claude Code CLI](https://claude.ai/claude-code) installed

## Customization

After running the script, customize these files for your project:

1. **CLAUDE.md**: Add project-specific instructions, tech stack details
2. **`.claude/rules/`**: Edit code-style.md and testing.md for your language/framework
3. **`.claude/settings.json`**: Add MCP servers, adjust permissions and hooks
4. **`.github/workflows/ci.yml`**: Add your language-specific setup and test commands

## License

MIT License - Use freely, attribution appreciated.

## Author

**Shelly Palmer** - [shellypalmer.com](https://www.shellypalmer.com)

---

*Version 4.0 - February 2026*
