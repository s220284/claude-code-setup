# Shelly Palmer's Claude Code Project Setup

A comprehensive setup script and programmer's guide for AI-assisted development with [Claude Code](https://claude.ai/claude-code).

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

The setup script generates a complete Claude Code project structure:

```
your-project/
├── CLAUDE.md              # Main instructions file (auto-loaded by Claude)
├── PROJECT_STATE.md       # System status tracker
├── SESSION_LOG.md         # Work history and continuity
├── .claude/
│   ├── settings.json      # Claude Code configuration
│   └── skills/
│       └── commit/        # Example skill for git commits
├── docs/
│   ├── agents.md          # Subagent documentation
│   ├── skills.md          # Skills system guide
│   └── STANDARDS.md       # Code quality standards
└── .github/
    └── workflows/
        └── ci.yml         # GitHub Actions workflow
```

## Key Features

- **Subagent Documentation**: How to use Explore, Plan, Bash, and general-purpose agents
- **Planning Mode Workflow**: When and how to use EnterPlanMode/ExitPlanMode
- **Skills System**: Creating custom slash commands
- **MCP Integration**: Model Context Protocol server configuration
- **Cloud-First Patterns**: Best practices for cloud deployment
- **Session Continuity**: Documentation structure for multi-session work

## Programmer's Guide

The full documentation is available at: **[s220284.github.io/claude-code-setup](https://s220284.github.io/claude-code-setup/)**

The guide covers:
- Complete script walkthrough
- Each generated file explained
- Subagent selection guidance
- Model selection (Haiku vs Sonnet vs Opus)
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

*Version 2.0 - January 2026*
