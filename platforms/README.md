# Platform Packaging

This directory packages the same capability body for multiple agent runtimes.

The source of truth is still:

- `roles/`
- `workflows/`
- `schemas/`
- `adapters/`
- `templates/`

Installed platform files are generated at install time and must be self-contained. If behavior changes, update the source role, adapter, or template first.

## Targets

| Platform | Package Form |
|---|---|
| Codex | skills generated from `templates/skill/` |
| Claude Code | skills generated from `templates/skill/` |
| OpenCode | agents generated from `templates/agent/` |
| OpenClaw | agents generated from `templates/agent/` |
| Human users | Markdown role and workflow manuals |

## Packaging Rule

Do not commit generated platform files. Keep long-form method content in `roles/` and backend-specific execution notes in `adapters/`.

## Install

Use the remote installer:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/aporicho/creative-agent-methods/main/install.sh)"
```

The installer asks for a platform, downloads the required role, adapter, and template files, renders self-contained output, and writes it to the target destination. The installed files do not depend on this repository being present locally.

Direct target install:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/aporicho/creative-agent-methods/main/install.sh)" -- codex
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/aporicho/creative-agent-methods/main/install.sh)" -- claude
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/aporicho/creative-agent-methods/main/install.sh)" -- opencode --project .
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/aporicho/creative-agent-methods/main/install.sh)" -- openclaw --project .
```

Use `--dry-run` to preview the generated output paths without writing files.
