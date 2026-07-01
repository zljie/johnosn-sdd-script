# Agent SDD — Cursor IDE Integration

<!-- AGENT_SDD_MARKER -->

This project uses the [Agent SDD Framework](./AGENTS.MD) for AI-driven software delivery.

## Cursor Rules

Rules are located in [`.cursor/rules/`](.cursor/rules/) and loaded automatically by Cursor:
- **[AGENTS.mdc](.cursor/rules/AGENTS.mdc)** — Entry point; `@`\-includes all sub-rules
- [agent-sdd-overview.mdc](.cursor/rules/agent-sdd-overview.mdc) — Framework overview
- [agent-sdd-artifacts.mdc](.cursor/rules/agent-sdd-artifacts.mdc) — Artifact types, schemas, templates
- [agent-sdd-lifecycle.mdc](.cursor/rules/agent-sdd-lifecycle.mdc) — Loop stages and state machines
- [agent-sdd-agents.mdc](.cursor/rules/agent-sdd-agents.mdc) — Agent roles and responsibilities
- [agent-sdd-loop-stages.mdc](.cursor/rules/agent-sdd-loop-stages.mdc) — Five loop stage definitions
- [agent-sdd-execution.mdc](.cursor/rules/agent-sdd-execution.mdc) — **MANDATORY** Execution Rule (state checking, guards, commands)

## Framework Structure

```
./
├── AGENTS.MD              # Full framework specification
├── INDEX.md               # Framework index
├── agent-sdd.yaml         # Project configuration
├── runtime-state.json     # Runtime state (memory)
├── loop/                  # Loop stage definitions
│   ├── 01-requirement.md
│   ├── 02-development.md
│   ├── 03-testing.md
printf├── agents/                # Agent role definitions
├── workflows/             # Workflow specifications
├── artifacts/             # Artifact instances
├── schemas/               # JSON Schema contracts
├── templates/             # Markdown templates
└── commands/              # SDD command protocols
    └── sdd-command-protocol.md
```

## Quick Start

1. **Start a loop**: Open \`./loop/01-requirement.md\` and follow the requirement workflow.
2. **Create an artifact**: Use a template from \`./templates/\`.
3. **Traceability**: Every artifact must declare its parent and children in the frontmatter.

## Commands

```bash
# Re-initialize Cursor rules (after framework update)
./scripts/agent-sdd-cursor-init.sh --force

# Add SPEC-KIT integration
./scripts/agent-sdd-cursor-init.sh --spec-kit

# Show all available rules
ls -la .cursor/rules/
```
