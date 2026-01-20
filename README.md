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

The setup script generates a streamlined Claude Code project structure:

```
your-project/
├── CLAUDE.md              # Main instructions file (auto-loaded by Claude)
├── PROJECT_STATE.md       # System status tracker
├── SESSION_LOG.md         # Work history and continuity
├── CONTINUATION_GUIDE.md  # Quick-start commands
├── .claude/
│   ├── settings.json      # Claude Code configuration
│   └── skills/
│       └── commit/        # Commit workflow skill
└── .github/
    └── workflows/
        └── ci.yml         # GitHub Actions workflow
```

## Key Features

- **Simplified Documentation**: v3.0 removes redundant files (agents.md, skills.md, STANDARDS.md) since Claude Code has built-in knowledge
- **Global Plugins**: Documents available plugins like feature-dev, pr-review-toolkit, frontend-design, and ralph-loop
- **Session Continuity**: Documentation structure for multi-session work
- **Cloud-First Patterns**: Best practices for cloud deployment
- **Skill Shortcuts**: Quick reference table for common workflows
- **MCP Integration**: Model Context Protocol server configuration

## Version 3.0 Improvements

v3.0 is a streamlined evolution that recognizes Claude Code's built-in capabilities:

- **Removed Redundancy**: No more agents.md, skills.md, or STANDARDS.md files
- **Focused CLAUDE.md**: Contains only project-specific guidance, not general Claude Code documentation
- **Plugin Documentation**: Global plugins (feature-dev, pr-review-toolkit, etc.) documented directly in CLAUDE.md
- **Cleaner Structure**: Fewer files, same power

## Programmer's Guide

The full documentation is available at: **[s220284.github.io/claude-code-setup](https://s220284.github.io/claude-code-setup/)**

The guide covers:
- Complete script walkthrough
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

1. **CLAUDE.md**: Add project-specific instructions, tech stack, conventions
2. **PROJECT_STATE.md**: Update with your actual system components
3. **.claude/settings.json**: Add MCP servers, adjust permissions

## License

MIT License - Use freely, attribution appreciated.

## Author

**Shelly Palmer** - [shellypalmer.com](https://www.shellypalmer.com)

---

*Version 3.0 - January 2026*
