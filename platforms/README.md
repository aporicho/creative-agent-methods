# Platform Packaging

This directory packages the same capability body for multiple agent runtimes.

The source of truth is still:

- `roles/`
- `workflows/`
- `schemas/`
- `adapters/`

Platform files should be thin wrappers. If behavior changes, update the source role or workflow first, then mirror the minimum necessary instruction into each platform package.

## Targets

| Platform | Package Form |
|---|---|
| Codex | skills under `platforms/codex/skills/` |
| Claude Code | skills or instruction files under `platforms/claude/skills/` |
| OpenCode | agent specs under `platforms/opencode/agents/` |
| OpenClaw | agent specs under `platforms/openclaw/agents/` |
| Human users | Markdown role and workflow manuals |

## Packaging Rule

Do not duplicate long-form method content unless the target platform requires it. Prefer small platform wrappers that point back to the shared role files.

## CLI Install

Use the remote installer:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/aporicho/creative-agent-methods/main/install.sh)"
```

The installer asks for a platform, downloads only that platform's required files, and writes them to the target destination.

Direct target install:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/aporicho/creative-agent-methods/main/install.sh)" -- codex
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/aporicho/creative-agent-methods/main/install.sh)" -- claude
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/aporicho/creative-agent-methods/main/install.sh)" -- opencode --project .
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/aporicho/creative-agent-methods/main/install.sh)" -- openclaw --project .
```

Maintainers can also use the repository CLI from a local checkout:

```bash
./bin/creative-agent-methods install codex
./bin/creative-agent-methods install claude
./bin/creative-agent-methods install opencode --dest /path/to/project/.opencode/agents
./bin/creative-agent-methods install openclaw --dest /path/to/project/.openclaw/agents
```

Use `--mode link` when you want the target platform to read directly from this repository, or the default copy mode when the target platform should receive standalone files.
